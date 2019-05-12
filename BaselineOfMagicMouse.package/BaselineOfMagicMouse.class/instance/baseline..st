baseline
baseline: spec
<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Cmfcmf' with: [
				spec
					repository: 'github://cmfcmf/SqueakUtils:master';
					loads: #('winffi')];
			package: 'MagicMouse-Core' with: [spec requires: #('Cmfcmf')].
		spec
			group: 'default' with: #('MagicMouse-Core');
			yourself];    
	yourself