export default {
  async fetch(request, env) {
    const targetHost='域名'
    let url = new URL(request.url)
    if (url.pathname.startsWith('/')) {
      url.hostname = targetHost
      let new_request = new Request(url, request)
      return fetch(new_request)
    }
    return env.ASSETS.fetch(request)
  }
}