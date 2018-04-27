pipeline{
    agent any
    environment{
        TAG='5.x'
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
                                def image = docker.build('schambm7/opencast-mt-source:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/.source/Dockerfile .")
                                image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build Base') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-base:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/.base/Dockerfile .")
                            image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build ActiveMQ') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-activemq:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/.source/Dockerfile .")
                                image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build MariaDB') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-mariadb:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/.base/Dockerfile .")
                            image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build Config') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-config:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/.base/Dockerfile .")
                            image.push("${env.TAG}")
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
                                def image = docker.build('schambm7/opencast-mt-allinone:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/allinone/Dockerfile .")
                                image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build Admin') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-admin:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/admin/Dockerfile .")
                            image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build Ingest') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-ingest:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/ingest/Dockerfile .")
                                image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build Presentation') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build('schambm7/opencast-mt-presentation:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/presentation/Dockerfile .")
                            image.push("${env.TAG}")
                            }
                        }
                    }
                }
                stage('Build Worker') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                                def image = docker.build('schambm7/opencast-mt-worker:${env.TAG}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg TAG=${env.TAG} -f Dockerfiles/worker/Dockerfile .")
                                image.push("${env.TAG}")
                            }
                        }
                    }
                }
            }
        }
    }
}
