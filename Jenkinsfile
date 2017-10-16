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
    stage('Module Installer') {
      steps {
        sh '$PUPPET module install rcoleman-puppet_module'
      }
    }
    stage('Google Modules') {
      steps {
        sh '''$PUPPET apply <<EOF

puppet_module { \'google-gauth\':
  ensure => present,
}

EOF'''
      }
    }
  }
  environment {
    MODULES = 'google-cloud'
    MODULE_DIR = '/etc/puppetlabs/code/environments/production/modules'
    PUPPET = '/opt/puppetlabs/bin/puppet'
  }
}