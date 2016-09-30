var Table = React.createClass({
    render: function () {
        var data = this.props.data;
        console.log(data.body);
        if (data.length != 0) {
            var header_text = data.head.map(function (header) {
                return (
                    <th key={ header }>{ header }</th>
                );
            });
            var body_text = data.body.map(function (body) {
                td_text = Object.keys(data.body[0]).map(function (key) {
                    return (
                        <td key={ body.id + key }>{ body[key] }</td>
                    );
                });
                return (
                    <tr key={ body.id }>
                        {td_text}
                    </tr>
                );
            });
        }
        return (
            <table className="table table-condensed table-bordered">
                <thead>
                <tr>
                    { header_text }
                </tr>
                </thead>
                <tbody>
                { body_text }
                </tbody>
            </table>
        );
    }
});