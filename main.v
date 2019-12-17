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

	server_code := "
fn users(req valval.Request) valval.Response {
    // create a view by template file 
    // `users.html` can be a relative or absolute path
    // use `element` (https://github.com/ElemeFE/element) as ui framework
    mut view := valval.new_view(req, 'users.html', 'element') or {
        return valval.response_bad(err)
    }
    
    users := [
        User{'Lucy', 13, false},
        User{'Lily', 13, false},
        User{'Jim', 12, true},
    ]
    // use view.set to bind data for rendering template
    // the second parameter must be a json string
    view.set('users', json.encode(users))
    view.set('msg', json.encode('This is a page of three user'))
    return valval.response_view(view)
}".trim_space()

	html_code := '
<html>
    <head>
        <title>Users Page</title>
    </head>
    <body>
        <!-- Content in body can use template syntax -->
        <h3>{{msg}}</h3>
        <p v-for="u in users">
            <span>{{u.name}}</span> ,
            <span>{{u.age}}</span> ,
            <el-tag v-if="u.sex">Male</el-tag>
            <el-tag v-else>Female</el-tag>
        </p>
    </body>
</html>'.trim_space()

	view.set('server_code', json.encode(server_code))
	view.set('html_code', json.encode(html_code))

	return valval.response_view(view)
}


fn main() {

	mut app := valval.new_app(true)

	app.serve_static('/static/', './static/')

	app.register('/', index)
	// app.register('*', index)

	valval.runserver(app, 8012)

}

