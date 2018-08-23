/**
This Jenkinsfile demonstrates Pipeline-as-Code for an example Webapp.
https://github.com/spring-projects/spring-petclinic

The Jenkinsfile proceeds through various stages of the build pipeline:
* Checkout webapp source code and build WAR.
  (Also Executes Unit Tests)
* Create a Tomcat Docker Image that also contains the WAR
* Deploy the Tomcat Image as a container into a server.
**/

node('master') {

  // where is the application source?
  def repoUrl = "https://github.com/spring-projects/spring-petclinic"


  // define a temporary workspace for building Docker images.
  def tempDir = pwd(tmp: true)

  //where is JDK located?
  def javaHome = "/usr/lib/jvm/java-1.8.0-openjdk-amd64"

  //what is the build command for petclinic?
  def buildCmd = "./mvnw install"
  
  //What is the daemon address?
  def dockerServer = "tcp://127.0.0.1:2375"

  //what is the path to the Dockerfile?
  def dockerfileLoc = "${env.WORKSPACE}@script/sample-dockerfiles/"

  // name of dockerfile to use, this is because the dir has multiple Dockerfiles named differently.
  def dockerfileName = "Dockerfile.build"

  //the version of the app from POM. 
  //TODO bad approach avoid this.
  def appVersion = "2.0.0.BUILD-SNAPSHOT"

  // Registry URL
  def registryURL = "127.0.0.1"
  // Docker Image Name
  def dockerImageName = "${registryURL}/savishy/tomcat-petclinic:${BUILD_NUMBER}"

  stage('Create Docker Workspace') {
    sh "cp ${dockerfileLoc}/${dockerfileName} ${tempDir}/Dockerfile"
    dir(tempDir) {
        sh "ls"
    }
  }

  stage('Checkout Petclinic App') {
    git url: "${repoUrl}"
  }
  
  stage("Build Petclinic ${appVersion} and Copy Artifact to Docker Workspace") {  
    sh "export JAVA_HOME=${javaHome} && ${buildCmd}"  
    sh "cp ./target/spring-petclinic-${appVersion}.jar ${tempDir}/petclinic.jar"
    archiveArtifacts artifacts: "**/target/*.jar"
  }

  stage("Build Docker Image ${dockerImageName}") {
    dir(tempDir) {
      sh "ls"
      docker.withServer(dockerServer) {
        dockerImage = docker.build(dockerImageName,".")
      }
    }
  }

  stage("Push Docker Image ${dockerImageName} To Registry") {
    docker.withRegistry("${registryURL}") {
      dockerImage.push()
    }
  }

}
