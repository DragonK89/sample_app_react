var Employee = React.createClass({
    loadEmployeesFromServer: function () {
        $.ajax({
            url: this.props.url,
            dataType: 'json',
            cache: false,
            success: function (data) {
                this.setState({
                    data: data
                });
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    handleEmployeeFilter: function (data) {
        this.setState({
            data: data
        });
    },
    handleTypeChange: function () {
        var type = this.state.new;
        this.setState({
            new: !type
        });
    },
    handleEmployeeSubmit: function (name, department_id, manager_id) {
        $.ajax({
            url: this.props.url,
            dataType: 'json',
            type: 'POST',
            data: {name: name, manager_id: manager_id, department_id: department_id},
            success: function (data) {
                this.setState({
                    data: data
                });
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    getInitialState: function () {
        return {
            data: [],
            new: false
        };
    },
    componentDidMount: function () {
        this.loadEmployeesFromServer();
    },
    render: function () {
        return (
            <div>
                <h1>Employees</h1>
                { this.state.new ? <EmployeeForm onEmployeeSubmit={this.handleEmployeeSubmit}/> :
                    <EmployeeFilter url_department="/departments_name" url_employee="/employees_name"
                                    onFilter={ this.handleEmployeeFilter } type={ this.state.new }/> }
                <input onClick={() => this.handleTypeChange()} type="button"
                       value={!this.state.new ? "New" : "Filter"}/>
                <Table data={ this.state.data }/>
            </div>
        );
    }
});

var EmployeeForm = React.createClass({
    getInitialState: function () {
        return {
            name: '',
            department_id: '',
            manager_id: '',
            defaults: ''
        };
    },
    handleNameChange: function (e) {
        name = e.target.value;
        this.setState({
            name: name
        });
    },
    handleDepartmentChange: function (department_id) {
        this.setState({
            department_id: department_id
        });
    },
    handleManagerChange: function (manager_id) {
        this.setState({
            manager_id: manager_id
        });
    },
    handleSubmit: function (e) {
        e.preventDefault();
        var name = this.state.name.trim();
        var department_id = this.state.department_id.trim();
        var manager_id = this.state.manager_id.trim();
        if (!name || !department_id) {
            return;
        }
        this.props.onEmployeeSubmit(name, department_id, manager_id != '' ? manager_id : null);
        this.setState({
            name: '',
            department_id: '',
            manager_id: '',
            defaults: ''
        });
    },
    render: function () {
        return (
            <form className="employeeForm" onSubmit={ this.handleSubmit }>
                <input type="text" placeholder="Employee Name" value={ this.state.name }
                       onChange={ this.handleNameChange }/>
                <EmployeeFilter url_department="/departments_name" url_employee="/employees_name"
                                onManagerChange={ this.handleManagerChange}
                                onDepartmentChange={ this.handleDepartmentChange} defaults={this.state.defaults}/>
                <input type="submit" value="New"/>
            </form>
        );
    }
});

var EmployeeFilter = React.createClass({
    loadDepartmentsFromServer: function () {
        $.ajax({
            url: this.props.url_department,
            dataType: 'json',
            cache: false,
            success: function (data) {
                this.setState({
                    departments: data
                });
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    loadManagersFromServer: function () {
        $.ajax({
            url: this.props.url_employee,
            dataType: 'json',
            cache: false,
            success: function (data) {
                this.setState({
                    managers: data
                });
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    FilterManagersFromServer: function (manager_id) {
        $.ajax({
            url: this.props.url_employee,
            dataType: 'json',
            type: 'POST',
            data: {manager_id: manager_id},
            success: function (data) {
                this.setState({
                    managers: data.employees,
                    defaults: data.defaults
                });
                if (this.props.onFilter)
                    this.props.onFilter(data.filter_employees);
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    FilterDepartmentsFromServer: function (department_id) {
        $.ajax({
            url: this.props.url_department,
            dataType: 'json',
            type: 'POST',
            data: {department_id: department_id},
            success: function (data) {
                this.setState({
                    managers: data.employees,
                });
                if (this.props.onFilter)
                    this.props.onFilter(data.filter_employees);
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    handleManagerChange: function (manager_id) {
        this.FilterManagersFromServer(manager_id);
        if (this.props.onManagerChange) {
            this.props.onManagerChange(manager_id);
        }
    },
    handleDepartmentChange: function (department_id) {
        this.FilterDepartmentsFromServer(department_id);
        if (this.props.onDepartmentChange) {
            this.props.onDepartmentChange(department_id);
        }
    },
    componentDidMount: function () {
        this.loadDepartmentsFromServer();
        this.loadManagersFromServer();
    },
    getInitialState: function () {
        return {
            departments: [],
            managers: [],
            defaults: ''
        };
    },
    render: function () {
        return (
            <div>
                <Select_box data={ this.state.departments } onChange={ this.handleDepartmentChange }
                            defaults={ this.props.defaults ? this.props.defaults : this.state.defaults }/>
                <Select_box data={ this.state.managers } onChange={ this.handleManagerChange }
                            defaults={ this.props.defaults ? this.props.defaults : this.state.defaults }/>
            </div>
        );
    }
});