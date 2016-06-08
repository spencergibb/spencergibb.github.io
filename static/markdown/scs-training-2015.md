# Spring Cloud

<style>img[alt=spring-cloud] { width: 40%; float: right; border: 0px solid #fff;}</style>

![spring-cloud](/images/spring-cloud.png)

Spencer Gibb<br>
twitter: [@spencerbgibb](http://twitter.com/spencerbgibb)<br>
http://spencer.gibb.us/preso<br>
email: sgibb@pivotal.io



<!-- .slide: data-background="/images/recipe_spring_framework.jpg" data-background-transition="zoom" -->



<!-- .slide: data-background="/images/recipe_spring_boot.jpg" data-background-transition="zoom" -->



<!-- .slide: data-background="/images/recipe_spring_cloud.jpg" data-background-transition="zoom" -->



### Example Distributed System: Minified

<style>img[alt=myfeed-blank] { width: 70%; }</style>

![myfeed-blank](/images/myfeed_arch_blank.svg)



## Features

* Bootstrap phase <!-- .element: class="fragment" -->
* Distributed configuration <!-- .element: class="fragment" -->
* Service registration and discovery <!-- .element: class="fragment" -->
* Circuit Breaker <!-- .element: class="fragment" -->
* Load balancing <!-- .element: class="fragment" -->
* Routing <!-- .element: class="fragment" -->
* Service-to-service calls <!-- .element: class="fragment" -->
* API Gateway <!-- .element: class="fragment" -->
* Distributed messaging <!-- .element: class="fragment" -->



### Example: Coordination Boiler Plate

<style>img[alt=myfeed-system] { width: 70%; }</style>

![myfeed-system](/images/myfeed_arch_system.svg)



<!-- .slide: data-background="#EE3424" data-background-transition="zoom" -->
## Netflix OSS

<style>img[alt=Netflix_logo] { width: 60%; float: right; }</style>

![Netflix_logo](/images/Netflix_logo.svg)

* Eureka
* Hystrix & Turbine
* Ribbon
* Feign
* Zuul
* Archaius
* ...



### Example: Spring Cloud and Netflix

<style>img[alt=myfeed] { width: 70%; }</style>

![myfeed](/images/myfeed_arch.svg)



## Configuration Server

<style>img[alt=gears] { width: 40%; float: right; }</style>

![gears](/images/gears.svg)

* Pluggable source
* Git implementation
  * Per service repos
* SVN implementation
* Versioned
* Rollback-able
* Configuration client <br>starts in bootstrap phase
* Managed by Spring Cloud<br>Services on PCF

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Discovery: Eureka

<style>img[alt=eureka] { width: 30%; float: right; }</style>

![eureka](/images/eureka.png)

* Service Registration Server
* Highly Available
* In AWS terms, multi Availability<br>Zone and Region aware
* Server managed by Spring<br>Cloud Services on PCF

http://techblog.netflix.com/2012/09/eureka.html

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Client Side Load-balancing: Ribbon

<style>img[alt=ribbon] { width: 30%; float: right; }</style>

![ribbon](/images/ribbon.png)

* Client side load balancer
* Pluggable
* Round robin, random,<br>weighted response time

http://techblog.netflix.com/2013/01/announcing-ribbon-tying-netflix-mid.html

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Declarative Rest Client: Feign

* Pluggable Codecs, Clients and Annotations
* Aims to be simple
* Creates a proxy from a Java interface

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Circuit Breaker: Hystrix

<style>img[alt=hystrix-logo] { float: right; }</style>

![hystrix-logo](/images/hystrix-logo.png)

* latency and fault tolerance
* isolates access to other services
* stops cascading failures
* enables resilience
* circuit breaker pattern
* dashboard

http://techblog.netflix.com/2012/11/hystrix.html


## Hystrix

<style>img[alt=hystrix] { width: 92%; }</style>

![hystrix](/images/HystrixGraph.svg)


## Hystrix Fallback

<style>img[alt=hystrix] { width: 92%; }</style>

![hystrix](/images/HystrixFallback.svg)



## Circuit Breaker Metrics

* Via actuator `/metrics`
* Server side event stream `/hystrix.stream`
  * also via rabbitmq
* Dashboard app via `@EnableHystrixDashboard`
* Dashboard managed by Spring Cloud Services on PCF

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Routing: Zuul

<style>img[alt=zuul] { width:30%; float: right; }</style>

![zuul](/images/zuul.png)

* JVM based router and filter
* Similar routing role as httpd,<br>nginx, or CF go router
* Fully programmable rules and filters
* Groovy
* Java
* any JVM language

http://techblog.netflix.com/2013/06/announcing-zuul-edge-service-in-cloud.html


## How Netflix uses Zuul
* Authentication
* Insights
* Stress Testing
* Canary Testing
* Dynamic Routing
* Service Migration
* Load Shedding
* Security
* Static Response handling
* Active/Active traffic management

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Spring Cloud Actuator

| Spring Cloud Commons | Spring Cloud Netflix |
|---|---|
| `/env` (POST)       | `/routes` (POST) |
| `/pause` (POST)     |  `/routes` (GET) |
| `/refresh` (POST)   |  `/hystrix.stream/**` (GET) |
| `/restart` (POST)   |  |
| `/resume` (POST)    |  |

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Spring Cloud Bus

* Distributed actuator
* `/bus/env` and `/bus/refresh` actuator endpoints
* _uses Spring Cloud Stream!_

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## No soup for you!

![nojava](/images/nojava.png)


## Spring Cloud Sidecar

<style>img[alt=sidecar] { width: 30%; float: right; }</style>

![sidecar](/images/Vespa_sidecar.png)

* For you non-java apps
* Modeled after Netflix Prana
* Built in zuul proxy

http://techblog.netflix.com/2014/11/prana-sidecar-for-your-netflix-paas.html

<blockquote>DEMO</blockquote> <!-- .element: class="fragment" -->



## Spring Cloud Security

Enable Single Sign On (SSO) with an OAuth2 provider declared in external properties.

```
@EnableOAuth2Sso
```
Enable security using OAuth2 access tokens

```
@EnableOAuth2Resource
```



## Spring Cloud Brixton

Milestones:

* [Spring Cloud](https://github.com/spring-cloud/spring-cloud-consul) [Consul](http://consul.io): Config, Discovery, Bus, Leader Election, Locks
* [Spring Cloud](https://github.com/spring-cloud/spring-cloud-zookeeper) [Zookeeper](http://zookeeper.apache.org): Config, Discovery, Locks, Leader Election
* [Spring Cloud Sleuth](https://github.com/spring-cloud-incubator/spring-cloud-sleuth) distributed tracing

_Previews, experiments or ideas_ (ie: **no guarantees!**)
* [Spring Cloud](https://github.com/spring-cloud-incubator/spring-cloud-etcd) [Etcd](https://github.com/coreos/etcd): Config, Discovery, Locks, Leader Election



## Links

* https://github.com/spring-cloud
* http://spencer.gibb.us/preso/spring-cloud-dcjug-2015.html
* https://github.com/spencergibb/oscon2015
* https://github.com/spring-cloud-samples
* http://blog.spring.io
* Twitter: [@spencerbgibb](http://twitter.com/spencerbgibb), [@david_syer](http://twitter.com/david_syer)
* Email: sgibb@pivotal.io, dsyer@pivotal.io


## Rx Java

<style>img[alt=rx-logo] { width: 15%; float: right; }</style>

![rx-logo](/images/Rx_Logo_M.png)

* Reactive: push vs. pull
* Functional
* Composable
* Return `Observable` from Spring MVC<br>Controller (soon)
* API Gateway combining services


## Rx Java Example
```
public static void hello(String... names) {
    Observable.from(names).subscribe(s -> {
            System.out.println("Hello " + s + "!");
    });
}
```

Sample functions:

* map
* flatMap
* zip
* take
* merge
* 350+ operators!

http://techblog.netflix.com/2013/02/rxjava-netflix-api.html


## Notes

* https://speakerdeck.com/mstine/architecting-for-continuous-delivery-microservices-with-pivotal-cf-and-spring-cloud
* http://www.slideshare.net/ewolff/micro-services-small-is-beautiful
* http://martinfowler.com/articles/microservices.html
* http://davidmorgantini.blogspot.com/2013/08/micro-services-what-are-micro-services.html


## Notes cont.

* Book (Humble and Farley): http://continuousdelivery.com
* http://techblog.netflix.com/2013/08/deploying-netflix-api.html
* [Mikey Cohen Netflix edge architecture, http://goo.gl/M159zi](http://goo.gl/M159zi)
* https://pragprog.com/book/mnee/release-it
* https://github.com/ReactiveX/RxJava
* http://reactivex.io


## Spring Restdocs

* Programatically generated snippets from unit tests!
* Hand write **asciidoc** docs including generated snippets

```
[source,http]
----
HTTP/1.1 200 OK
Content-Type: application/hal+json

{
  "_links" : {
    "users" : {
      "href" : "http://localhost:11070/users{?page,size,sort}",
      "templated" : true
    },
    "profile" : {
      "href" : "http://localhost:11070/alps"
    }
  }
}
----
```
https://github.com/spring-projects/spring-restdocs


## Spring Session

* Generic vendor session abstraction
* Can be used in any environment, not just web

__`@EnableRedisHttpSession`__

http://projects.spring.io/spring-session


## Continuous Delivery

* Microservices lend themselves to continuous delivery.
* You actually *need* continuous delivery to extract maximum value.
* **New:** ALM support in Cloudfoundry from Cloudbees


## Cloudfoundry

* Environment Provisioning
* On-Demand/Automatic Scaling
* Failover/Resilience
* Routing/Front-end Load Balancing
* Monitoring

Deploying services needs to be simple and reproducible

```
$ cf push app.groovy
```

and you don't get much more convenient than that.

(Same argument for other PaaS solutions)


### Micro vs Monolithic... is NOT new

```
From:         kt4@prism.gatech.EDU (Ken Thompson)
Subject:      Re: LINUX is obsolete
Date:         3 Feb 92 23:07:54 GMT
Organization: Georgia Institute of Technology

I would generally agree that microkernels are probably the wave
of the future. However, it is in my opinion easier to implement
a monolithic kernel. It is also easier for it to turn into a
mess in a hurry as it is modified.

Regards, Ken
```

![mono-vs-micro-os](/images/mono-vs-micro-os.svg)


### What's wrong with a monolith?

![monolith](/images/monolith.jpg)
