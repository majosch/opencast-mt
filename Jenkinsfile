pipeline{
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    environment{
        GIT_HASH = "${env.GIT_COMMIT[0..7]}"
        BRANCH='amc-develop'
    }
    parameters {
            booleanParam(name: 'AUTO_DEPLOY', defaultValue: false, description: 'AutoDeploy:')
            string(name: 'ARTIFACTS_PROJECT_NAME', defaultValue: 'AMC_OPENCAST', description: 'Define Project Name:')
    }
    stages{
      stage('Hash') {
          steps {
              echo "${env.BRANCH_NAME}"
              echo "${env.GIT_COMMIT}"
          }
        }
        stage('Build Prerequisites') {
            parallel {
                stage('Build Base') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                               def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-base:${env.BRANCH}","--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git","--build-arg branch=${env.BRANCH}","-f Dockerfiles/.base/Dockerfile Dockerfiles/.base")
                               image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
    }
}
