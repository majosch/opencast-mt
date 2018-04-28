pipeline{
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    environment{
        GIT_HASH = "${env.GIT_COMMIT[0..7]}"
        BRANCH='amc-develop'
    }
    stages{
      stage('Hash') {
          steps {
              echo "${env.BRANCH_NAME}"
              echo "${env.BRANCH}"
              echo "${env.GIT_COMMIT}"
          }
        }
        stage('Build Prerequisites') {
            parallel {
                stage('Build Base') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                               def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-base:${env.BRANCH}","--build-arg branch=${env.BRANCH} --build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git -f Dockerfiles/.base/Dockerfile Dockerfiles/.base")
                               image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Source') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                               def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-source:${env.BRANCH}","--build-arg branch=${env.BRANCH} --build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git -f Dockerfiles/.source/Dockerfile Dockerfiles/.source")
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
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-base:${env.BRANCH}","--build-arg branch=${env.BRANCH} --build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git -f Dockerfiles/activemq/Dockerfile Dockerfiles/activemq")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build MariaDB') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-mariadb:${env.BRANCH}","--build-arg branch=${env.BRANCH} --build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git -f Dockerfiles/mariadb/Dockerfile Dockerfiles/mariadb")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Config') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-config:${env.BRANCH}","--build-arg branch=${env.BRANCH} --build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git -f Dockerfiles/config/Dockerfile Dockerfiles/config")
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
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-allinone:${env.BRANCH}","-f Dockerfiles/allinone/Dockerfile .")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Admin') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-admin:${env.BRANCH}", "-f Dockerfiles/admin/Dockerfile Dockerfiles/admin")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Ingest') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-ingest:${env.BRANCH}", "-f Dockerfiles/ingest/Dockerfile Dockerfiles/ingest")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Presentation') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-presentation:${env.BRANCH}","-f Dockerfiles/presentation/Dockerfile Dockerfiles/presentation")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Worker') {
                    steps {
                        withDockerRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']) {
                            script {
                                def image = docker.build("registry.oc.univie.ac.at/amc/opencast-mt-worker:${env.BRANCH}","-f Dockerfiles/worker/Dockerfile Dockerfiles/worker")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
    }
}
