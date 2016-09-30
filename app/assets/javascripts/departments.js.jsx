var Department = React.createClass({
    loadDepartmentsFromServer: function () {
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
    filterDepartmentsFromServer: function (value) {
        $.ajax({
            url: this.props.url,
            dataType: 'json',
            type: 'POST',
            data: {filter: value},
            success: function (data) {
                this.setState({
                    data: data,
                    value: value
                });
            }.bind(this),
            error: function (xhr, status, err) {
                this.setState({
                    data: value
                });
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    handelChangeSlider: function (e) {
        const value = e.target.value;
        setTimeout(this.filterDepartmentsFromServer(value),500);
    },
    getInitialState: function () {
        return {
            data: [],
            value: 0
        };
    },
    componentDidMount: function () {
        this.loadDepartmentsFromServer();
    },
    render: function () {
        return (
            <div>
                <h1>Departments</h1>
                <div>
                    <h3>Minimum number of employees:{this.state.value}</h3>
                    <input type="range" name="points" min="0" value={this.state.value}
                           onChange={this.handelChangeSlider}
                           max={this.state.data.length != 0 ? this.state.data.employee_count.scount - 1 : 100}/>
                </div>
                <Table data={ this.state.data }/>
            </div>
        );
    }
});
