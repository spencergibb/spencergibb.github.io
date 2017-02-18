<style>#the-api-gateway-is-dead- { font-size: 2em; }</style>
<style>#long-live-the-api-gateway- { font-size: 2em; }</style>

## The API Gateway is Dead!
## Long Live the API Gateway!

<br>
Spencer Gibb<br>
twitter: [@spencerbgibb](http://twitter.com/spencerbgibb)<br>
email: sgibb@pivotal.io



<!-- .slide: data-background="#000000" -->
<style>#there-is-no-dana-only-zuul- { color: white; }</style>

## There is no Dana, only Zuul!
![zuul](/images/zuul.png)

<style>img[alt=zuul] { width: 100%; }</style>

Note:
History:
  - AWS early adopter
  - Uses (Security, surgical routing, Load Shedding, etc...)
  - All Netflix clusters behind single Zuul behind ELB



## Zuul Design

![zuul-lifecycle](/images/zuul-lifecycle.png)

Note:
- Global filter scope (each filter determines if it should be run)
- `RequestContext`



# Filters in Zuul Core

## ???



## Zuul in Spring Cloud Netflix

## `@EnableZuulProxy`

Note:
- Default Filters installed
- URL Path routing only
- Properties & `DiscoveryClient` route definitions



## Spring Cloud Netflix Filters

* PreDecorationFilter <!-- .element: class="fragment" -->
* SendForwardFilter <!-- .element: class="fragment" -->
* RibbonRoutingFilter <!-- .element: class="fragment" -->
* SimpleHostRoutingFilter <!-- .element: class="fragment" -->
* SendResponseFilter <!-- .element: class="fragment" -->
* SendErrorFilter <!-- .element: class="fragment" -->



## Custom Route Matching Filter

```
public class QueryParamPreFilter extends ZuulFilter {
	public int filterOrder() {
		// run before PreDecorationFilter
		return PRE_DECORATION_FILTER_ORDER - 1;
	}
	public String filterType() {
		return PRE_TYPE;
	}
	// continued...
}
```



## Custom Route Matching Filter Cont.

```
public class QueryParamPreFilter extends ZuulFilter {
	// continued from previous

	public Object run() {
		RequestContext ctx = RequestContext.getCurrentContext();
		HttpServletRequest request = ctx.getRequest();
		if (request.getParameter("foo") != null) {
		    // put the serviceId in `RequestContext`
    		ctx.put(FilterConstants.SERVICE_ID_KEY, 
    				request.getParameter("foo"));
    	}
        return null;
    }
}
```



## Custom Routing Filter

```
public class OkHttpRoutingFilter extends ZuulFilter {
	@Autowired
	private ProxyRequestHelper helper;
	public Object run() {
		OkHttpClient httpClient = new OkHttpClient.Builder()
			// customize
			.build();
		RequestContext context = RequestContext.getCurrentContext();
		HttpServletRequest request = context.getRequest();
		String method = request.getMethod();
		String uri = this.helper.buildZuulRequestURI(request);
    // continued...
	}
}
```



### Custom Routing Filter Cont.

```
	public Object run() {
		// continued from previous
		// Translate headers from Servlet to OkHttp
		Headers.Builder headers = new Headers.Builder();
		Enumeration<String> headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String name = headerNames.nextElement();
			Enumeration<String> values = request.getHeaders(name);
			while (values.hasMoreElements()) {
				String value = values.nextElement();
				headers.add(name, value);
			}
		}
		// continued...
	}
```



### Custom Routing Filter Cont.

```
	public Object run() {
		// continued from previous
		// Translate input stream
		InputStream inputStream = request.getInputStream();
		RequestBody requestBody = null;
		if (inputStream != null && HttpMethod.permitsRequestBody(method)) {
			MediaType mediaType = null;
			if (headers.get("Content-Type") != null) {
				mediaType = MediaType.parse(
						(headers.get("Content-Type"));
			}
			requestBody = RequestBody.create(mediaType,
					StreamUtils.copyToByteArray(inputStream));
		}
		// continued...
	}
```



### Custom Routing Filter Cont.

```java
	public Object run() {
		// continued from previous
		// Make request
		Request.Builder builder = new Request.Builder()
				.headers(headers.build())
				.url(uri)
				.method(method, requestBody);

		Response response = httpClient.newCall(builder.build()).execute();
		// continued...
	}
```



### Custom Routing Filter Cont.

```java
	public Object run() {
		// continued from previous
		// Make request
		LinkedMultiValueMap<String, String> responseHeaders =
				 new LinkedMultiValueMap<>();
		for (Map.Entry<String, List<String>> entry :
				response.headers().toMultimap().entrySet()) {
			responseHeaders.put(entry.getKey(), entry.getValue());
		}
		this.helper.setResponse(response.code(),
				response.body().byteStream(),
				responseHeaders);
		// prevent SimpleHostRoutingFilter from running
		context.setRouteHost(null);
		return null; // ?!huh?
	}
```



### Custom Modify Response Filter

```java
public class AddResponseHeaderFilter extends ZuulFilter {
	public String filterType() {
		return POST_TYPE;
	}

	public int filterOrder() {
		return SEND_RESPONSE_FILTER_ORDER - 1;
	}

	public boolean shouldFilter() {
		return true;
	}
	// continued
}
```



### Custom Modify Response Filter

```java
public class AddResponseHeaderFilter extends ZuulFilter {
	// continued from previous
	public Object run() {
		RequestContext context = RequestContext.getCurrentContext();
		HttpServletResponse servletResponse = context.getResponse();
		servletResponse.addHeader("X-Foo",
				UUID.randomUUID().toString());
		return null;
	}
}
```



## Problems?

- Large coupled filters <!-- .element: class="fragment" -->
- Filter model/API is clunky <!-- .element: class="fragment" -->



## Zuul 2

http://techblog.netflix.com/2016/09/zuul-2-netflix-journey-to-asynchronous.html

- Major rewrite <!-- .element: class="fragment" -->
- Not backwards compatible with Zuul 1 <!-- .element: class="fragment" -->
- Non-blocking/Netty <!-- .element: class="fragment" -->
- Not released yet <!-- .element: class="fragment" -->
- HTTP/2 and Websockets in the future <!-- .element: class="fragment" -->
- Reinvents many things from Spring <!-- .element: class="fragment" -->
- Soooo..... <!-- .element: class="fragment" -->



<!-- .slide: data-background="#6db33f" data-background-transition="zoom" -->
## Introducing
# Spring Cloud Gateway <!-- .element: class="fragment" -->



## Spring Cloud Gateway

- Java 8/Spring 5/Boot 2
- Finchley Release Train (Q4 2017)
- HTTP/2 and Websockets
- WebFlux/Reactor



## Route Matching

In Spring Handler Mapping
```yml
id: host_foo_path_headers_to_httpbin
  uri: http://httpbin.org:80
  predicates:
  - Host=**.foo.org
  - Url=/headers
  - Method=GET
  - Header=X-Request-Id, \d+
  - Query=foo, ba.
  - Query=baz
  - Cookie=chocolate, ch.p
  - After=1900-01-20T17:42:47.789-07:00[America/Denver]
```



## Filters
Scoped for an individual Route

- `AddResponseHeader=X-Response-Foo, Bar` <!-- .element: class="fragment" -->
- `RemoveResponseHeader=X-Request-Foo` <!-- .element: class="fragment" -->
- `SecureHeaders` <!-- .element: class="fragment" -->
- `RewritePath=/foo/(?<part>.*), /$\{part}` <!-- .element: class="fragment" -->
- `RedirectTo=302, http://example.org` <!-- .element: class="fragment" -->
- `Hystrix=mycmd` <!-- .element: class="fragment" -->



## Other Features

* API Driven <!-- .element: class="fragment" -->
* Route definitions: Properties, Discovery, DB? <!-- .element: class="fragment" -->
* Flexible, less need for custom filters <!-- .element: class="fragment" -->



## Zuul 1?

* Sticks around <!-- .element: class="fragment" -->
* Possible compatibility layer <!-- .element: class="fragment" -->



## Spencer Gibb
github: https://github.com/spring-cloud-incubator/spring-cloud-gateway
blog: http://spencer.gibb.us
twitter: [@spencerbgibb](http://twitter.com/spencerbgibb)<br>
email: sgibb@pivotal.io
