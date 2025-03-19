def gv

pipeline {
    agent any
    tools {
        nodejs 'my-nodejs'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    def version = sh(script: "npm version minor --no-git-tag-version", returnStdout: true).substring(1).trim()
                    env.IMAGE_NAME = "${version}-${BUILD_NUMBER}"
                    echo "${IMAGE_NAME}"

                    //proposed solution
                    //sh "npm version minor —no-git-tag-version"
                    //def packageJson = readJSON file: 'package.json'
                    //def version = packageJson.version
                    //env.IMAGE_NAME = "$version-$BUILD_NUMBER"

                    // another proposed solution
                    //alternative solution without Pipeline Utility Steps plugin: 
                    //def version = sh (returnStdout: true, script: "grep 'version' package.json | cut -d '\"' -f4 | tr '\\n' '\\0'")
                    //env.IMAGE_NAME = "$version-$BUILD_NUMBER"
   
                }
            }
        }
        stage('build app') {
            steps {
                script {
                    echo 'building the application...'
                    sh 'npm install'
                }
            }
        }
        stage('test') {
            steps {
                script {
                    sh 'npm run test'
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                    sh "docker image build -t ncortim/app:${IMAGE_NAME} ."
                    sh 'echo ${PASS} | docker login -u ${USER} --password-stdin'
                    sh "docker push ncortim/app:${IMAGE_NAME}"
                    }
                }
            }
        }
        //stage('deploy') {
        //    steps {
        //        script {
        //            echo 'deploying docker image...'
        //        }
        //    }
        //}
        stage('commit version update'){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'gtihub-token', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'

                        sh 'git remote set-url origin https://${USER}:${PASS}@github.com/ncortim/jenkins-exercise'
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:main'
                    }
                }
            }
        }
    }
}
