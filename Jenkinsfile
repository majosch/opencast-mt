pipeline{
    agent any
    environment{
        BRANCH='amc-develop'
    }
    stages{
        stage('Build Prerequisites')
        {
            parallel {
                stage('Build Source') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-source:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.source/Dockerfile .")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Base') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-base:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
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
                                def image = docker.build('schambm7/opencast-mt-activemq:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.source/Dockerfile .")
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
                            def image = docker.build('schambm7/opencast-mt-mariadb:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
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
                            def image = docker.build('schambm7/opencast-mt-config:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
        stage('Build Opencast Node Images')
        {
            parallel {
                stage('Build All-In-One') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-allinone:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/allinone/Dockerfile .")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Admin') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-admin:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/admin/Dockerfile .")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Ingest') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-ingest:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/ingest/Dockerfile .")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Presentation') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-presentation:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/presentation/Dockerfile .")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Worker') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-worker:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/worker/Dockerfile .")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
    }
}
