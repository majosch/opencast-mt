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
        stage('Build Prerequisites')
        {
            parallel {
                stage('Build Base') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-base:${env.BRANCH}","--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git","--build-arg branch=${env.BRANCH}","-f Dockerfiles/.base/Dockerfile Dockerfiles/.base")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build ActiveMQ') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-base:${env.BRANCH}","--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git","--build-arg branch=${env.BRANCH}","-f Dockerfiles/activemq/Dockerfile Dockerfiles/activemq")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build MariaDB') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-mariadb:${env.BRANCH}", "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git","--build-arg branch=${env.BRANCH}","-f Dockerfiles/mariadb/Dockerfile Dockerfiles/mariadb")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Config') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-config:${env.BRANCH}", "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/config/Dockerfile Dockerfiles/config")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
    }
}
