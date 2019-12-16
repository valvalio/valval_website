module main

// git clone https://github.com/toajy123/valval
// ln -s $(pwd)/valval ~/.vmodules/valval
// git clone https://github.com/toajy123/valval_website
// cd valval_website && v run main.v
// 
// curl http://127.0.0.1:8012

import (
	valval
	json
)


fn index(req valval.Request) valval.Response {

	mut view := valval.new_view(req, 'template/index.html', 'element') or {
		return valval.response_bad(err)
	}

	view.set('total_count', json.encode(1))

	return valval.response_view(view)
}


fn main() {

	mut app := valval.new_app(true)

	app.serve_static('/static/', './static/')

	app.register('/', index)
	// app.register('*', index)

	valval.runserver(app, 8012)

}

