pipeline{
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    environment{
        GIT_HASH = "${env.GIT_COMMIT[0..7]}"
        BRANCH='develop'
        REPO='https://github.com/opencast/opencast.git'
        NODEPREFIX='amc/opencast-mt'
        REGISTRYURL='registry.oc.univie.ac.at'
    }
    stages{
      stage('Hash') {
          steps {
              echo "${env.BRANCH_NAME}"
              echo "${env.BRANCH}"
              echo "${env.GIT_COMMIT}"
              echo "${env.GIT_HASH}"
          }
        }
        stage('Build Prerequisites') {
            parallel {
                stage('Build Base') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                               def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-base:${env.BRANCH}","-f Dockerfiles/.base/Dockerfile Dockerfiles/.base")
                               image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Source') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                               def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-source:${env.BRANCH}","--build-arg branch=${env.BRANCH} --build-arg repo=${env.REPO} -f Dockerfiles/.source/Dockerfile Dockerfiles/.source")
                               image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
        stage('Build required services') {
            parallel {
                stage('Build ActiveMQ') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-activemq:${env.BRANCH}","-f Dockerfiles/activemq/Dockerfile Dockerfiles/activemq")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build MariaDB') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-mariadb:${env.BRANCH}","--build-arg tag=${env.BRANCH} --build-arg registry=${env.REGISTRYURL} --build-arg nodeprefix=${env.NODEPREFIX} -f Dockerfiles/mariadb/Dockerfile Dockerfiles/mariadb")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Config') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-config:${env.BRANCH}","-f Dockerfiles/config/Dockerfile Dockerfiles/config")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
        stage('Build Opencast Node Images') {
            parallel {
                stage('Build All-In-One') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-allinone:${env.BRANCH}","--build-arg tag=${env.BRANCH} -f Dockerfiles/allinone/Dockerfile Dockerfiles/allinone")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Admin') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-admin:${env.BRANCH}", "--build-arg tag=${env.BRANCH} -f Dockerfiles/admin/Dockerfile Dockerfiles/admin")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Ingest') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-ingest:${env.BRANCH}", "--build-arg tag=${env.BRANCH} -f Dockerfiles/ingest/Dockerfile Dockerfiles/ingest")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Presentation') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-presentation:${env.BRANCH}","--build-arg tag=${env.BRANCH} -f Dockerfiles/presentation/Dockerfile Dockerfiles/presentation")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Worker') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: "https://${env.REGISTRYURL}"]) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-worker:${env.BRANCH}","--build-arg tag=${env.BRANCH} -f Dockerfiles/worker/Dockerfile Dockerfiles/worker")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
    }
}
