export default {
  async fetch(request, env) {
    const url = new URL(request.url)
    url.protocol = 'https:'
    url.hostname = '域名'
    return fetch(new Request(url, request))
  }
}
