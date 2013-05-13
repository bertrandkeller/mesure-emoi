// Configure these parameters before you start.
var API_KEY = '{{ site.gadash.api_key }}';
var CLIENT_ID = '{{ site.gadash.client_id[site.env] }}';
var TABLE_ID = '{{ site.gadash.table_id }}';


// Format of table ID is ga:xxx where xxx is the profile ID.

gadash.configKeys({
  'apiKey': API_KEY,
  'clientId': CLIENT_ID
});

// Create a new Chart that queries visitors for the last 30 days and plots
// visualizes in a line chart.
var chartvisits = new gadash.Chart({
  'type': 'LineChart',
  'divContainer': 'chart-visits',
  'last-n-days':30,
  'query': {
    'ids': TABLE_ID,
    'metrics': 'ga:visits',
    'dimensions': 'ga:date'
  },
  'chartOptions': {
    height: 200,
    title: 'Dernières visites',
    vAxis: {title:'Visites'},
    curveType: 'function'
  }
}).render();

var chartperformance = new gadash.Chart({
  'type': 'LineChart',
  'divContainer': 'chart-performance',
  'last-n-days':30,
  'query': {
    'ids': TABLE_ID,
    'metrics': 'ga:pageLoadTime',
    'dimensions': 'ga:date'
  },
  'chartOptions': {
    height: 200,
    title: 'Performances',
    vAxis: {title:'Visites'},
    curveType: 'function'
  }
}).render();

var chartsource = new gadash.Chart({
  'type': 'PieChart',
  'divContainer': 'chart-source',
  'last-n-days':30,
  'query': {
    'ids': TABLE_ID,
    'metrics': 'ga:visitors',
    'dimensions': 'ga:medium',
  },
  'chartOptions': {
    height: 200,
    title: 'Recherches',
    vAxis: {title:'Visites'},
    curveType: 'function'
  }
}).render();

var chartpage = new gadash.Chart({
  'type': 'Table',
  'divContainer': 'chart-page',
  'last-n-days':30,
  'query': {
    'ids': TABLE_ID,
    'metrics': 'ga:visitors',
    'dimensions': 'ga:pageTitle',
		'sort': '-ga:visitors',
		'max-results': 5,
  },
  'chartOptions': {
    height: 200,
		width: 300,
    title: 'Langues',
    vAxis: {title:'Visites'},
    curveType: 'function'
  }
}).render();


