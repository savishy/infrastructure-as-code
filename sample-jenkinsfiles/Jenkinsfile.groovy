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
  def dockerfileLoc = "${env.WORKSPACE}@script/docker/petclinic/"
  def tempDir = pwd(tmp: true)
  def javaHome = "/usr/lib/jvm/java-1.8.0-openjdk-amd64"
  stage('Create Docker WS') {
    sh "cp ${dockerfileLoc}/Dockerfile ${tempDir}"
    dir(tempDir) {
        sh "ls"
    }
  }

  stage('Build Petclinic and Copy to Docker WS') {
  
    sh "export JAVA_HOME=${javaHome} && ${buildCmd}"
  
  
  
    common.checkoutGit("https://github.com/spring-projects/spring-petclinic")
    common.buildWar("/usr/lib/jvm/java-1.8.0-openjdk-amd64","./mvnw install")
    //def appVersion = common.getMavenProjectVersion()
    def appVersion = "1.5.1"
    sh "cp ./target/spring-petclinic-${appVersion}.jar ${tempDir}/petclinic.jar"
    archiveArtifacts artifacts: "**/target/*.jar"
  }


  stage('Build Docker Image') {
    dir(tempDir) {
        sh "ls"
      common.buildDockerImage(
        "savishy/tomcat-petclinic:${BUILD_NUMBER}",
        "."
      )
    }
  }

  stage('Push Docker Image To Registry') {
    echo "This stage pushes the image to registry"
  }

  stage('Deploy Docker Image') {
    echo "This is where we would use Ansible to deploy the docker image into a server."
  }
}
