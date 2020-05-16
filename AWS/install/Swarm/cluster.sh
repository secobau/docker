#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug"	|| exit 100					;
test -n "$stack"	|| exit 100					;
#########################################################################
service=docker								;
#########################################################################
targets=" InstanceManager1 " 						;
#########################################################################
service_wait_targets $service $stack "$targets"				;
#########################################################################
command=" sudo docker swarm init | grep token --max-count 1 " 		;
token_worker="$(							\
  send_wait_targets "$command" $stack "$targets"			\
  )"									;	
#########################################################################
command=" sudo docker swarm join-token manager | grep token " 		;
token_manager="$(							\
  send_wait_targets "$command" $stack "$targets"			\
  )"									;	
#########################################################################
targets=" InstanceManager2 InstanceManager3 " 				;
#########################################################################
service_wait_targets $service $stack "$targets"				;
#########################################################################
command=" sudo $token_manager " 					;
send_wait_targets "$command" $stack "$targets"				;
#########################################################################
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " 		;
#########################################################################
service_wait_targets $service $stack "$targets"				;
#########################################################################
command=" sudo $token_worker " 						;
send_wait_targets "$command" $stack "$targets"				;
#########################################################################
