pipeline {
    agent any
	tools {
		maven 'Maven'
	}
	
	environment {
		PROJECT_ID = 'grand-harbor-391707'
                CLUSTER_NAME = 'perftesting'
                LOCATION = 'us-central1-c'
                CREDENTIALS_ID = 'kubernetes'		
	}
	
    stages {
	    stage('Scm Checkout') {
		    steps {
			    checkout scm
		    }
	    }
	    
	    stage('Build') {
		    steps {
			    sh 'mvn clean package'
		    }
	    }
	    
	    stage('Build Docker Image') {
		    steps {
			    sh 'whoami'
			    script {
				    myimage = docker.build("sumanth17121988/petclinic:${env.BUILD_ID}")
			    }
		    }
	    }
	    
	    stage("Push Docker Image") {
		    steps {
			    script {
				    echo "Push Docker Image"
				    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
            				sh "docker login -u sumanth17121988 -p ${dockerhub}"
				    }
				        myimage.push("${env.BUILD_ID}")
				    
			    }
		    }
	    }
	    
	    stage('Deploy to K8s') {
		    steps{
			    echo "Deployment started ..."
			    sh 'ls -ltr'
			    sh 'pwd'
			    sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"
			    echo "Start deployment of deployment.yaml"
			    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
			    echo "Deployment Finished ..."
		    }
	    }
             stage('Performance tests') {
		    steps{
			    echo "Performance testing is started ..."
			    sh 'ls -ltr'
			    sh 'pwd'
			    sh '/home/perftest186/apache-jmeter-5.6.2/bin/jmeter.sh -n -t petstore.jmx -l petstore.csv'
                             echo "Performance testing is Completed..."
		    }
	    }
            stage('Analyse Performance Results') {
                        steps{
			        sh 'pwd'
                                 echo "Performance Test Report is getting ready"
                                perfReport compareBuildPrevious: true, filterRegex: '', ignoreFailedBuilds: true, ignoreUnstableBuilds: true, modeOfThreshold: true,relativeFailedThresholdPositive: 80.0, relativeUnstableThresholdPositive: 80.0, sourceDataFiles: 'petstore.csv'                             }
        }
    }
    }
}
