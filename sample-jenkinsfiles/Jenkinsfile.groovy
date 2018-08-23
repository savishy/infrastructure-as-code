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

  def dockerfileLoc = "${env.WORKSPACE}@script/sample-dockerfiles/"
  def repoUrl = "https://github.com/spring-projects/spring-petclinic"
  def tempDir = pwd(tmp: true)
  def javaHome = "/usr/lib/jvm/java-1.8.0-openjdk-amd64"
  def buildCmd = "./mvnw install"
  def dockerServer = "tcp://127.0.0.1:2375"

  stage('Create Docker Workspace') {
    sh "cp ${dockerfileLoc}/Dockerfile ${tempDir}"
    dir(tempDir) {
        sh "ls"
    }
  }

  stage('Checkout Petclinic App') {
    git url: "${repoUrl}"
  }
  
  stage('Build Petclinic App and Copy Artifact to Docker Workspace') {  
    sh "export JAVA_HOME=${javaHome} && ${buildCmd}"  
    //TODO avoid hardcoded product version
    def appVersion = "1.5.1"
    sh "cp ./target/spring-petclinic-${appVersion}.jar ${tempDir}/petclinic.jar"
    archiveArtifacts artifacts: "**/target/*.jar"
  }

  stage('Build Docker Image') {
    dir(tempDir) {
      sh "ls"
      docker.withServer(dockerServer) {
        def dockerImageName = "savishy/tomcat-petclinic:${BUILD_NUMBER}"
        docker.build(dockerImageName,".")
      }
    }
  }

  stage('Push Docker Image To Registry') {
    echo "This stage pushes the image to registry"
  }

}
