from plotly.offline import init_notebook_mode, iplot
from plotly import graph_objects as go


def verification_plot(output_folder, plot_filename, y_label='Value'):

    data_ref = pd.read_csv(output_folder+'/reference.csv', index_col=0)
    data_test = pd.read_csv(output_folder+'/test.csv', index_col=0)
    data_err = pd.read_csv(output_folder+'/errors.csv', index_col=0)
    data_low = pd.read_csv(output_folder+'/lowerBound.csv', index_col=0)
    data_upp = pd.read_csv(output_folder+'/upperBound.csv', index_col=0)

    data = [
        go.Scatter(
            x=data_err.index.values,
            y=data_err.y.values,
            name='Error',
            xaxis='x',
            yaxis='y2',
            line={'width': 5}
        ),
        go.Scatter(
            x=data_test.index.values,
            y=data_test.y.values,
            name='Controller Output',
            line={'width': 5}
        ),
        go.Scatter(
            x=data_low.index.values,
            y=data_low.y.values,
            showlegend=False,
            mode= 'lines',
            line={'width': 0}
        ),
        go.Scatter(
            x=data_ref.index.values,
            y=data_ref.y.values,
            name='CDL Reference Output',
            fillcolor='rgba(68, 68, 68, 0.3)',
            fill='tonexty',
            line={'width': 5}
        ),
        go.Scatter(
            x=data_upp.index.values,
            y=data_upp.y.values,
            fillcolor='rgba(68, 68, 68, 0.3)',
            fill='tonexty',
            showlegend=False,
            mode= 'lines',
            line={'width': 0}
        )
    ]

    layout = go.Layout(
        legend={
            'font': {
                'size':24
            },
            'yanchor': 'top',
            'y': 1.1,
            'xanchor': 'right',
            'x': 0.95
        },
        grid={
            'rows': 2,
            'columns': 1,
    #         'subplots': [['xy1'], ['xy2']]
        },
        xaxis1={
            'ticks': 'outside',
            'showline': True,
            'zeroline': False,
            'title': 'time [seconds]',
            'anchor': 'y1',
            'tickfont': {
              'size': 24,
            },
            'titlefont': {
              'size': 24
            },
        },
        yaxis1= {
            'automargin': True,
            'domain': [0.3, 1],
            'ticks': 'outside',
            'showline': True,
            'zeroline': False,
            'title': {
                'text': y_label,
            },
            'tickfont': {
              'size': 24,
            },
            'titlefont': {
              'size': 24
            },
        },
        yaxis2= {
            'automargin': True,
            'domain': [0, 0.15],
            'ticks': 'outside',
            'showline': True,
            'zeroline': False,
            'title': 'error [y]',
            'tickfont': {
              'size': 24,
            },
            'titlefont': {
              'size': 24
            },
        },
        height=750,
        width=1200,
        template='plotly_white'
    )
    fig = go.Figure(data=data, layout=layout)
    fig.write_image(plot_filename)