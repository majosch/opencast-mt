pipeline{
    agent any
    environment{
        BRANCH='amc-develop'
    }
    stages{
        stage('Build Prerequisites')
        {
            parallel {
                stage('Build Base') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry([credentialsId: 'PORTUS_JENKINS_LOGIN', url: 'https://registry.oc.univie.ac.at']){
                            def image = docker.build("schambm7/opencast-mt-base:${env.BRANCH}", "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
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
                                def image = docker.build("schambm7/opencast-mt-activemq:${env.BRANCH}", "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.source/Dockerfile .")
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
                            def image = docker.build("schambm7/opencast-mt-mariadb:${env.BRANCH}", "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
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
                            def image = docker.build("schambm7/opencast-mt-config:${env.BRANCH}", "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
                            image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
            }
        }
    }
}
