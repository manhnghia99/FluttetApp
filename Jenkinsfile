pipeline {
    agent any

    stages {
        stage('GIT PULL') {
            steps {
                git branch: 'main', url: 'https://github.com/manhnghia99/FluttetApp.git'
            }
        }
        stage('TEST') {
            steps {
                sh 'echo "moi"'
                sh 'flutter test'
            }
        }
        stage('BUILD') {
            steps {
                sh '''
                  #!/bin/sh
                  flutter build apk --debug
                  '''
            }
        }
        stage('DISTRIBUTE') {
            steps {
                appCenter apiToken: '90d7180db4e268bcf1c590f1d26d8c85727f51e1',
                        ownerName: 'thanhnghia29-gmail.com',
                        appName: 'FlutterApp1',
                        pathToApp: 'build/app/outputs/apk/debug/app-debug.apk',
                        distributionGroups: 'TestAlpha'
            }
        }
    }
}
