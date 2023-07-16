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
	    
	    stage('Performance tests') {
		    steps{
			    echo "Performance testing is started ..."
			    sh 'ls -ltr'
			    sh 'pwd'
			    sh '/home/perftest186/apache-jmeter-5.6.2/bin/jmeter.sh -n -t petstore.jmx -l petstore.csv'
		    }
	    }
            stage('Analyse Performance Results') {
                        steps{
			        sh 'pwd'
                                perfReport compareBuildPrevious: true, filterRegex: '', ignoreFailedBuilds: true, ignoreUnstableBuilds: true, modeOfThreshold: true,relativeFailedThresholdPositive: 80.0, relativeUnstableThresholdPositive: 80.0, sourceDataFiles: 'petstore.csv'                             }
        }
    }
}
