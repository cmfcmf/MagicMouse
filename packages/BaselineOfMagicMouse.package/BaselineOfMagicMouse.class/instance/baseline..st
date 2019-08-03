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
			package: 'JSON' with: [spec repository: 'http://www.squeaksource.com/JSON'];
			package: 'MagicMouse-Core' with: [spec requires: #('Cmfcmf' 'OSProcess' 'JSON')];
			package: 'MagicMouse-Tests' with: [spec requires: #('MagicMouse-Core')].
		spec
			group: 'default' with: #('MagicMouse-Core');
			group: 'tests' with: #('MagicMouse-Tests');
			yourself];    
	yourself