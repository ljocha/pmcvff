import plotly.graph_objs as go
import plotly.express as px

def plot_landmarks(x1, y1, x2="None", y2="None"):
        data = {'x': x2,
                'y': y2}
        fig = px.scatter(data, x="x", y="y", hover_data=['y'])
        if x2 != "None":
                fig.add_scatter(x=x1, y=y1, mode='markers', marker_size=10)
        return fig
