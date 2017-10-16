pipeline {
  agent any
  stages {
    stage('Puppet Setup') {
      steps {
        sh '''# RPM setup
if ! rpm -q puppetlabs-release-pc1; then
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi'''
        sh '''# Puppet setup
if ! rpm -q puppet-agent; then
  yum install -y puppet-agent
fi
'''
      }
    }
    stage('Bolt Setup') {
      steps {
        sh '$PUPPET resource package gcc-c++ ensure=present'
        sh '''$PUPPET resource package bolt \\
  ensure=present provider=puppet_gem'''
      }
    }
    stage('Google Modules') {
      steps {
        sh '''$PUPPET resource package google-api-client \\
  ensure=present provider=puppet_gem

$PUPPET resource package googleauth \\
  ensure=present provider=puppet_gem'''
        sh '''if ! puppet module list | grep google-cloud; then
  puppet module install google-cloud
fi'''
      }
    }
  }
  environment {
    MODULES = 'google-cloud'
    MODULE_DIR = '/etc/puppetlabs/code/environments/production/modules'
    PUPPET = '/opt/puppetlabs/bin/puppet'
  }
}