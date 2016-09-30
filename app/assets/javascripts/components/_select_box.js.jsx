var Select_box = React.createClass({
    handleChange: function (e) {
        var data = e.target.value;
        this.props.onChange(data);
    },
    render: function () {
        var data = this.props.data;
        var defaults = this.props.defaults;
        if (data.length != 0) {
            var option_text = data.map(function (option) {
                return (
                    defaults != '' && defaults == option[0] ?
                        <option key={ option[0] } value={ option[0] } selected="selected">{ option[1] }</option>
                        :
                        <option key={ option[0] } value={ option[0] }>{ option[1] }</option>
                );
            });
        }
        return (
            <select className="" onChange={this.handleChange}>
                <option></option>
                { option_text }
            </select>
        );
    }
});