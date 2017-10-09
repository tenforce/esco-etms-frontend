eraseCookieFromAllPaths = (name) ->
    pathBits = location.pathname.split('/')
    pathCurrent = ' path='

    document.cookie = name + '=; expires=Thu, 01-Jan-1970 00:00:01 GMT;';

    for i in [0...(pathBits.length-1)]
        pathCurrent += ((pathCurrent.substr(-1) != '/') ? '/' : '') + pathBits[i]
        document.cookie = name + '=; expires=Thu, 01-Jan-1970 00:00:01 GMT;' + pathCurrent + ';'

`export default eraseCookieFromAllPaths`

