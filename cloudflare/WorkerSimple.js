addEventListener('fetch', (event) => {
  let url = new URL(event.request.url)
  url.hostname = 'xxx.mybluemix.net'
  let request = new Request(url, event.request)
  event.respondWith(fetch(request))
})
