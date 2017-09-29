#!/bin/bash

puppet job run --query 'resources[certname] { type = "Class" and title = "Profile::Myapp" }'
