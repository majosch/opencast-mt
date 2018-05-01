pipeline{
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    environment{
        GIT_HASH = "${env.GIT_COMMIT[0..7]}"
        BRANCH='amc-r/5.x'
        REPO='https://github.com/academic-moodle-cooperation/opencast.git'
        //REPO='https://github.com/opencast/opencast.git'
        NODEPREFIX='amc/opencast-mt'
        REGISTRYURL='registry.oc.univie.ac.at'
        DOCKERTAG="5.x"
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
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                               def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-base:${env.DOCKERTAG}","-f Dockerfiles/.base/Dockerfile Dockerfiles/.base")
                               image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build Source') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                               def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-source:${env.DOCKERTAG}","--build-arg branch=${env.BRANCH} --build-arg repo=${env.REPO} -f Dockerfiles/.source/Dockerfile Dockerfiles/.source")
                               image.push("${env.DOCKERTAG}")
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
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-activemq:${env.DOCKERTAG}","-f Dockerfiles/activemq/Dockerfile Dockerfiles/activemq")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build MariaDB') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-mariadb:${env.DOCKERTAG}","--build-arg tag=${env.DOCKERTAG} --build-arg registry=${env.REGISTRYURL} --build-arg nodeprefix=${env.NODEPREFIX} -f Dockerfiles/mariadb/Dockerfile Dockerfiles/mariadb")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build Config') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-config:${env.DOCKERTAG}","-f Dockerfiles/config/Dockerfile Dockerfiles/config")
                                image.push("${env.DOCKERTAG}")
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
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-allinone:${env.DOCKERTAG}","--build-arg tag=${env.DOCKERTAG} -f Dockerfiles/allinone/Dockerfile Dockerfiles/allinone")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build Admin') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-admin:${env.DOCKERTAG}", "--build-arg tag=${env.DOCKERTAG}", "--build-arg registry=${env.REGISTRYURL}", "--build-arg nodeprefix=${env.NODEPREFIX} -f Dockerfiles/admin/Dockerfile Dockerfiles/admin")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build Ingest') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-ingest:${env.DOCKERTAG}", "--build-arg tag=${env.DOCKERTAG} -f Dockerfiles/ingest/Dockerfile Dockerfiles/ingest")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build Presentation') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-presentation:${env.DOCKERTAG}","--build-arg tag=${env.DOCKERTAG} -f Dockerfiles/presentation/Dockerfile Dockerfiles/presentation")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
                stage('Build Worker') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://${env.REGISTRYURL}']) {
                            script {
                                def image = docker.build("${env.REGISTRYURL}/${env.NODEPREFIX}-worker:${env.DOCKERTAG}","--build-arg tag=${env.DOCKERTAG} -f Dockerfiles/worker/Dockerfile Dockerfiles/worker")
                                image.push("${env.DOCKERTAG}")
                            }
                        }
                    }
                }
            }
        }
    }
}
