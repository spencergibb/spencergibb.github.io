+++
categories = []
date = "2015-09-24T10:48:18-06:00"
description = ""
keywords = []
title = "Spring Cloud Config Push Notifications"

+++

[This commit (8d8e07a78)](https://github.com/spring-cloud/spring-cloud-config/commit/8d8e07a78e73c3e1e08f4277a76c6e1a4104f103)
by [Dave Syer](https://github.com/dsyer) in [spring-cloud-config](https://github.com/spring-cloud/spring-cloud-config)
added support for [push notifications](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html#_push_notifications_and_spring_cloud_bus)
to config clients.

**NOTE:** I am using [HTTPie](https://github.com/jkbrzt/httpie) (pronounced _aych-tee-tee-pie_) for these demos. I believe it provides a more user friendly experience. To install on a mac with [Homebrew](http://brew.sh/): `brew install httpie`, otherwise see [the install docs](https://github.com/jkbrzt/httpie#installation).

## Dependencies

```xml
<parent>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-parent</artifactId>
  <version>Brixton.BUILD-SNAPSHOT</version>
  <relativePath /> <!-- lookup parent from repository -->
</parent>
<dependencies>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-monitor</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bus-redis</artifactId>
    <!-- or -amqp (rabbitmq) or -kafka -->
  </dependency>
<!-- ... -->
</dependencies>
```

I'm using redis, installed via Homebrew. The bus dependency needs to be in configserver and each config client.

I simply modified the [sample configserver](https://github.com/spring-cloud-samples/configserver) who's main method starts out like this.

```java
@Configuration
@EnableAutoConfiguration
@EnableDiscoveryClient
@EnableConfigServer
public class ConfigServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ConfigServerApplication.class, args);
	}

}
```

## Manual push

The `/monitor` endpoint includes a form encoded post that you can trigger as follows:
```bash
http --form POST :8888/monitor path=configserver
```

This allows you to develop your own hooks. It also allows for a central api to manually trigger refresh events.

## Remote Refresh Event

Config clients need to have the following dependencies (again, assuming redis) from `Brixton.BUILD-SNAPSHOT`

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-config</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-bus-redis</artifactId>
  <!-- or -amqp (rabbitmq) or -kafka -->
</dependency>
```

When a successful event is received, you should see something like this in the logs:

```
2015-09-24 12:15:54.257  INFO 11202 --- [enerContainer-2] o.s.cloud.bus.event.RefreshListener      : Received remote refresh request. Keys refreshed [info.description]
```

## Gitlab webhook

The Gitlab wehbhook doesn't list the files that changed, so all applications will receive a refresh event. That's the reason I don't have a specific configuration in the simulation link below.

```java
@Bean
public GitlabPropertyPathNotificationExtractor gitlabPropertyPathNotificationExtractor() {
  return new GitlabPropertyPathNotificationExtractor();
}
```

To simulate the gitlab webhook:

```bash
http --json POST :8888/monitor X-Gitlab-Event:"Push Event" commits:='[{}]'
```

## Github webhook

Github  reports what files were added, deleted and modified and attempts to only send notifications to the impacted services.

```java
@Bean
public GithubPropertyPathNotificationExtractor githubPropertyPathNotificationExtractor() {
  return new GithubPropertyPathNotificationExtractor();
}
```

To simulate the github webhook:
```bash
http --json POST :8888/monitor X-Github-Event:"push" commits:='[{"modified": ["configserver.yml"] }]'
```

### Test github via ngrok:

[Install ngrok](https://ngrok.com/download) first.

```bash
ngrok 8888
```

Add `https://41b2063a.ngrok.com/monitor` to you config repo's github webhooks settings. Commit changes and profit!

## Filesystem watcher

For the `native` file based repository, a watch is created that polls the filesystem for changes. If a change is found, a change event is sent.
