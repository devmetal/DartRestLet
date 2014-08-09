part of restlet.resource;

abstract class ResourceFactory {
  Resource createResource(String url);
}

class GETFactory extends ResourceFactory {
  @override
  Resource createResource(String url) {
    return new Resource("GET", url);
  }
}

class POSTFactory extends ResourceFactory {
  @override
  Resource createResource(String url) {
    return new Resource("POST",url);
  }
}

class PUTFactory extends ResourceFactory {
  @override
  Resource createResource(String url) {
    return new Resource("PUT", url);
  }
}

class DELETEFactory extends ResourceFactory {
  @override
  Resource createResource(String url) {
    return new Resource("DELETE",url);
  }
}