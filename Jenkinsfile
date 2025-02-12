pipeline {
    agent any
    parameters {
        string(name: 'MYSQL_ROOT_PASSWORD', defaultValue: 'root', description: 'MySQL password')
    }
    stages {
        stage ("Initialize Jenkins Env") {
         steps {
            sh '''
            echo "PATH = ${PATH}"
            echo "M2_HOME = ${M2_HOME}"
            '''
         }
        }
        stage('Download Code') {
            steps {
               echo 'checking out'
               checkout scm
            }
        }
        stage('Execute Tests'){
            steps {
                echo 'Testing'
                sh 'mvn test'
            }
        }
        stage('Build Application'){
            steps {
                echo 'Building...'
                sh 'mvn clean install -Dmaven.test.skip=true'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t priyanka18feb/User_front .'
            }
        }
       stage('Create Database') {
            steps {
                echo 'Running Database Image'
            //    sh 'docker kill bankmysql 2> /dev/null'
            //    sh 'docker kill cloudbank 2> /dev/null'
            //    sh 'docker rm bankmysql 2> /dev/null'
            //    sh 'docker rm cloudbank 2> /dev/null'
                sh 'docker stop bankmysql || true && docker rm bankmysql || true'
                sh 'docker run --detach --name=bankmysql --env="MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" -p 3306:3306 mysql'
                sh 'sleep 20'
            //  sh 'docker exec -i bankmysql mysql -uroot -proot < sql_dump/ICNIBankDatabase.sql'
                sh 'docker exec -i bankmysql mysql -uroot -p${MYSQL_ROOT_PASSWORD} < sql_dump/ICNIBankDatabase.sql'
            }
        }
        stage('Deploy and Run') {
            steps {
                echo 'Running Application'
                sh 'docker stop cloudbank || true && docker rm cloudbank || true'
                sh 'docker run --detach --name=cloudbank -p 8888:8888 --link bankmysql:localhost -t priyanka18feb/User_front'
            }
        }
    }
}