pipeline{
    agent any
    environment{
        BRANCH='amc-develop'
    }
    stages{
        stage('Build Images')
        {
            parallel {
                stage('Build Source') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry('https://registry.oc.univie.ac.at'){
                                def image = docker.build('schambm7/opencast-mt-source:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.source/Dockerfile .")
                                image.push("${env.BRANCH}")
                            }
                        }
                    }
                }
                stage('Build Base Image') {
                    agent any
                    steps {
                    script {
                        docker.withRegistry('https://registry.oc.univie.ac.at'){
                            def image = docker.build('schambm7/opencast-base:${env.BRANCH}', "--build-arg repo=https://github.com/academic-moodle-cooperation/opencast.git --build-arg branch=${env.BRANCH} -f Dockerfiles/.base/Dockerfile .")
                            image.push("${env.BRANCH}")
                        }
                    }
                }
            }
        }
    }
}
