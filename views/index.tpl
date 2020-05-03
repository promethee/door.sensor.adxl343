<html>
  <head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.3.0/socket.io.js" integrity="sha256-bQmrZe4yPnQrLTY+1gYylfNMBuGfnT/HKsCGX+9Xuqo=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js" integrity="sha256-R4pqcOYV8lt7snxMQO/HSbVCFRPMdrhAFMH+vr9giYI=" crossorigin="anonymous"></script>
    <style type="text/css">
      /* Chart.js */
      @keyframes chartjs-render-animation{from{opacity:.99}to{opacity:1}}.chartjs-render-monitor{animation:chartjs-render-animation 1ms}.chartjs-size-monitor,.chartjs-size-monitor-expand,.chartjs-size-monitor-shrink{position:absolute;direction:ltr;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1}.chartjs-size-monitor-expand>div{position:absolute;width:1000000px;height:1000000px;left:0;top:0}.chartjs-size-monitor-shrink>div{position:absolute;width:200%;height:200%;left:0;top:0}
    </style>
  </head>
  <body>
    <div style="width: 75%">
      <canvas id="myChart" width="200" height="200"></canvas>
    </div>
    <ul id="links" style="width: 100%"></ul>
    <script>
      ['linear', 'logarithmic'].map(type => [10, 100].map(delta => {
        const link = document.createElement('a');
        link.setAttribute('href', `?type=${type}&delta=${delta}`);
        link.innerText = `${type} with ${delta} milliseconds delta update`;
        const li = document.createElement('li');
        li.appendChild(link);
        document.querySelector('#links').appendChild(li);
      }));

      const ctx = document.getElementById('myChart').getContext('2d');
      const chart = new Chart(ctx, {
        type: 'line',
        data: {
          datasets: [{
            label: 'x',
            backgroundColor: '#f00',
            borderColor: '#f00',
            fill: false,
            pointRadius: 0,
            lineTension: 0,
            data: []
          },
          /*{
            label: 'y',
            backgroundColor: '#0f0',
            borderColor: '#0f0',
            fill: false,
            pointRadius: 0,
            lineTension: 0,
            data: []
          },*/
          {
            label: 'z',
            backgroundColor: '#00f',
            borderColor: '#00f',
            fill: false,
            pointRadius: 0,
            lineTension: 0,
            data: []
          }],
	      },
	      options: {
          scales: {
            xAxes: [{
                display: true,
            }],
              yAxes: [{
                display: true,
		            type: (t => t === 'linear' ? t : 'logarithmic')((new URLSearchParams(window.location.search)).get('type') || 'linear')
              }]
          }
	      }
      });

      const max_values = {
        1: 1000,
        10: 100,
        100: 50,
        1000: 20
      };

      const defaultInterval = 100;
      const queryInterval = (new URLSearchParams(window.location.search)).get('delta');
      const interval = parseInt(queryInterval || defaultInterval);
      const max = max_values[interval];

      const add = (t, datasets) => {
        chart.data.labels.push(t);
        const labelLength = chart.data.labels.length;
        if (labelLength > max) chart.data.labels = chart.data.labels.slice(labelLength - max);
        datasets.map((dataset, i) => {
          chart.data.datasets[i].data.push(dataset);
          const dataLength = chart.data.datasets[i].data.length;
          if (dataLength > max) chart.data.datasets[i].data = chart.data.datasets[i].data.slice(dataLength - max);
        });
        chart.update();
      };

      setInterval(async () => {
        const response = await fetch('/data');
        const { t, x, y, z } = await response.json();
        const time = (new Date(t * 1000)).toISOString().split('T')[1];
        add(time, [
          { x: time, y: x },
          { x: time, y: z }
        ]);
      }, interval);

    </script>
  </body>
</html>
