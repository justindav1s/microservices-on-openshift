// camel-k: trait=3scale.enabled=true trait=container.limit-memory=256Mi 
import org.apache.camel.builder.RouteBuilder;

public class ThreeScaleRest extends RouteBuilder {

  @Override
  public void configure() throws Exception {
      rest().get("/")
        .route()
        .setBody().constant("Hello");
  }
}
