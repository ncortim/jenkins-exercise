def gv

pipeline {
    agent any
    //tools {
    //    maven 'maven-3.9.9'
    //}
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'VERSION_FULL=$(npm version minor)'
                    sh "VERSION=$(echo "$VERSION" | sed 's/^v//')"

                    //sh 'mvn build-helper:parse-version versions:set \
                    //    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                    //    versions:commit'
                    //def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    //def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
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
                        sh "docker build -t ncortim/app:${IMAGE_NAME} ."
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
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
                    withCredentials([usernamePassword(credentialsId: 'github-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/ncortim/exercises/tree/main/08-build-automation-and-CI-CD-with-jenkins/jenkins-exercises/app                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}
