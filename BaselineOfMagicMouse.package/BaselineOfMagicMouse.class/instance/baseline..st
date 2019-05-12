baseline
baseline: spec
<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Cmfcmf' with: [
				spec
					repository: 'github://cmfcmf/SqueakUtils:master';
					loads: #('winffi')];
			project: 'OSProcess' with: [
				spec
					className: 'ConfigurationOfOSProcess';
					repository: 'http://www.squeaksource.com/MetacelloRepository';
					versionString: #'stable'];
			package: 'MagicMouse-Core' with: [spec requires: #('Cmfcmf' 'OSProcess')].
		spec
			group: 'default' with: #('MagicMouse-Core');
			yourself];    
	yourself