+++
categories = ["notes"]
date = "2015-03-11T09:45:06-07:00"
description = ""
keywords = ["spring-cloud", "spring", "clud"]
title = "Spring Cloud Devnexus Notes"
draft = true
skipSidebar = true

+++

## Monolithic vs Microservices

* Easy/Hard vs Simple/Complex
* Monolithic
  * Complex / Easy
  * Language / Framework modularity
  * Fewer scaling vectors
  * Long-term commitment to tech stack
  * coupled changes make harder deploys
  * hard to scale dev
* Microservice
  * Simple / Hard
  * for continuous delivery
  * 12 factor apps
  * diversity of clients (mobile, desktop, devices)
  * modularity based on services
  * uncoupled changes enable frequent deploys
  * more scaling vectors
  * dev friendly
  * easier to scale dev
  * no long term commitment to tech stack
  
## Microservices with Spring Boot

* partition strategies
  * Noun (product info service)
  * Verb (shipping service)
  * Single Responsibility Principle
  * Bounded Context
* Polyglot persistence
* Unix pipes and filters
* Choreography vs Orchestration

## No Man (Microservice) is an Island

* No free lunch
  * Ops overhead
  * Substantial Devops Skills required
  * Implicit interfaces
  * Duplication of effort
  * Distributed System complexity
  * Asynchronicity is difficult
  * Testability chalenges
  
Spring CLI Support
http command is from httpie.org
  
## Configuration Server

cd ~/workspace/spencergibb/myfeed

show ConfigApp
start config server

http -a user:password :11020/admin/health  
http -a user:password :11020/myapp/default  
http -a user:password :11020/myfeed-ui/development
http -a user:password :11020/myfeed-ui/development/test


### Config Client

run myfeed-ui
http :11040/env

http :11040/info
http --form :11040/env info.foo=bar
http :11040/env
http :11040/info

http --form :11040/env logging.level.ROOT=DEBUG
http --form :11040/env logging.level.com.netflix=OFF

open UiApp
show @RefreshScope

http :11040/ui/features
http --form :11040/env myfeed.ui.featureAaaFlag=devnexus
http POST :11040/refresh
http :11040/ui/features

change a value at https://github.com/spencergibb/myfeed-config

http POST :11040/refresh

http POST :11040/shutdown


### encryption/decryption

cat /Users/sgibb/workspace/spencergibb/myfeed-config/application.yml
http -a user:password :11020/myapp/default # show encrypted.password

export TESTVAL=`spring encrypt --key=foobar this is a test`  
echo $TESTVAL  
spring decrypt --key=foobar $TESTVAL

cli and server also support keystores

## Discovery: Eureka

open DiscoveryApp
start eureka  
http://discovery.myfeed.com:11010/

open CustomerApp.java
start Ui again

show eureka dashboard  
http :11040/metrics # or http://ui.myfeed.com:11040/metrics

by default configserver gives eureka address, can setup eureka to locate configserver

## Ribbon and Hystrix

open AdminApp, show LoadBalancerClient

open feed UserService and show HystrixCommand

open TurbineApp and start

open AdminApp, show @EnableHystrixDashboard

start admin app
start feed app


hit this over and over and break circuit  
http://feed.myfeed.com:11060/@spencergibb

goto http://admin.myfeed.com:11050/admin/
show dashboard

start users

hit customers over and over again  
show dashboard

open feed UserService again and show RestTemplate

open UiApp and show @FeignClientScan
open UiController and show Feign and client call

Uses Spring MVC annotations  
Uses Spring HttpMessageConverters configured by spring boot

## Rx Java

show UiController.feed
show FeedService.feed


## Routing: Zuul

open RoutingApp
start router

http://www.myfeed.com:11080

cat /Users/sgibb/workspace/spencergibb/myfeed-config/myfeed-router.yml

http :11081/routes

run other ui's

hit http://www.myfeed.com:11080/whoami

## Spring Cloud Security

show RouterApp and router application.yml
show UiApp and ui application.yml

Spring Session Redis for AdminApp

## Spring Cloud Bus

http --form :11081/bus/env logging.level.ROOT=INFO
http --form :11081/bus/env my.prop=my.val
http POST :11081/bus/refresh

open s-c-bus  
extend RemoteApplicationEvent  
publish to ApplicationEventPublisher.publish(event)

ability to extend to other messaging systems besids RabbitMQ

## Spring Cloud Sidecar

open s-c-netflix  
open SidecarApplication

run sidecar

http :11100
http :11100/ping
http :11100/health

shut down local server  
http :11100/health

run local server  
http :11100/health

web interface for discovery  
http :11100/hosts/configserver etc...

zuul proxy  
http :11100/myfeed-user
http :11100/myfeed-feed/@spencergibb

proxy to configserver
http -a user:password :11100/configserver/myapp-default.yml

## Spring Restdocs

./myfeed-user/target/myfeed-user-1.0.0.BUILD-SNAPSHOT.jar --server.port=11072

http://localhost:11072/docs/api-guide.html

http://localhost:11072/docs/getting-started-guide.html

## Spring Session Redis

open RouterApp show @EnableRedisHttpSession

show admin application.yml show security part


## Preview: Spring Cloud Consul

cat run_consul.sh  
./run_consul.sh

open http://consului.local.spring.io:8500

open s-c-consul

show sample pom.xml  
show SampleApplication  
run SampleApplication

http :8080/health

show consul ui services

http :8080/myenv prop==myprop

add testConsulApp property through consul ui

run SampleApplication 8083

run this until 8083 shows up  
http :8080/

http POST :8083/shutdown   
http :8080/

run SampleApplication 8083

http --form :8080/bus/env my.value=consul.value  

http :8080/bus/refresh

