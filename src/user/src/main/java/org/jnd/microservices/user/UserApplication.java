package org.jnd.microservices.user;



import org.jnd.microservices.user.proxies.BasketRepositoryProxy;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
@PropertySources({
        @PropertySource(value = "classpath:config.${spring.profiles.active:default}.properties",  ignoreResourceNotFound = true),
        @PropertySource(value = "file:/config/config.${spring.profiles.active:default}.properties", ignoreResourceNotFound = true)
})
@EnableAutoConfiguration
@SpringBootApplication
@RestController
public class UserApplication extends SpringBootServletInitializer {

    @Autowired
    private BasketRepositoryProxy basketRepositoryProxy;

    public static void main(String[] args) {
        SpringApplication.run(UserApplication.class, args);
    }

    @RequestMapping(value = "/health", method = RequestMethod.GET)
    public String ping() {
        return "OK";
    }

    @RequestMapping(value = "/loginhealth", method = RequestMethod.GET)
    public String route() {

        String basketHealth = "BASKET : "+basketRepositoryProxy.getBasketHealth();

        return basketHealth+" | USER : OK";
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home() {
        return "USER OK";
    }

}
