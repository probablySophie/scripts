// Write all of the colour variables we can find to the document body
// This is mostly for pasting into the console

let root_styles = [];
Object.values(document.styleSheets).forEach( stylesheet => {
	if ( stylesheet == null ) { return }
	if ( stylesheet.rules == null ) { return }
	Object.values(stylesheet.rules).filter( rule => rule.selectorText != null /* && rule.selectorText.indexOf(":root") != -1 */ ).forEach( rule => { root_styles.push(rule) } );
} )

let variable_sets = [];
root_styles.forEach( style => {
	let variables = [];
	Object.values( style.style ).forEach( style_var => {
		if ( style_var.startsWith("--") ) {
			variables.push(style.cssText.match( new RegExp( style_var + ":.*?;" ) )[0]);
		}
	} )
	variable_sets.push( {rule: style.selectorText, variables} )
} )

let block_size = "30px";
make_the_guy = (text, kind) => {
	let matches = text.match( /^([^\:]*):\s*(.*?);*$/ );
	let name = matches[1];
	let value = matches[2];

	let container = document.createElement("div");
	container.style.position = "relative";

	let box = document.createElement("div");
	box.style.width = block_size;
	box.style.height = block_size;
	box.style.border = "1px solid white";
	let box2 = document.createElement("div");
	box2.style.border = "1px solid black";
	box2.appendChild(box);

	if ( kind == "colour" ) {
		box.style.backgroundColor = value;
	} else if ( kind == "image" ) {
		box.style.backgroundPosition = "center center";
		box.style.backgroundSize = "contain";
		box.style.backgroundImage = value.trim();
	}

	let popup = document.createElement("div");
	popup.style.backgroundColor = "white";
	popup.style.color = "black";
	popup.style.display = "none";
	popup.style.flexDirection = "column";
	popup.style.gap = "5px";
	popup.style.position = "absolute";
	popup.style.fontSize = "15px";
	popup.style.width = "max-content";
	popup.style.padding = "5px";
	popup.style.zIndex = "5";
	popup.style.transform = `translateX(calc(-50% + ${block_size} ))`;

	popup.appendChild(make_span(name));
	popup.appendChild(make_span(value));

	container.addEventListener("mouseenter", () => { popup.style.display = "flex" });
	container.addEventListener("mouseleave", () => { popup.style.display = "none" });

	container.appendChild(box2);
	container.appendChild(popup);
	return container
}

make_span = (text) => {
	let s = document.createElement("span");
	s.innerText = text.length < 40 ? text : text.slice(0, 40) + "...";
	s.addEventListener("click", () => {
		navigator.clipboard.writeText(text)
	})
	return s
}

for ( const variable_set of variable_sets )
{
	let colour_variables = variable_set.variables.filter( v => false
		|| v.match( /\:\s*rgba{0,1}\(.*\)/ ) != null
		|| v.match( /\:\s*\#/ ) != null
	);
	let url_variables = variable_set.variables.filter( v => false
		|| v.match( /\:\s*url\("data\:image.*\)/ ) != null
	);

	if ( colour_variables.length == 0 && url_variables.length == 0 ) {
		// let new_guy = document.createElement("span");
		// new_guy.innerText = variable_set.rule;
		// document.body.appendChild(new_guy);
		// document.body.appendChild( document.createElement("br") );
		continue
	}

	let my_div = document.createElement("div");
	// my_div.style.display = "grid";
	// my_div.style.gridTemplateColumns = "repeat(3, min-content)";
	my_div.style.display = "flex";
	my_div.style.flexWrap = "wrap";
	my_div.style.gap = "20px";
	my_div.style.padding = "5px 10%";

	let heading = document.createElement("h3");
	heading.innerText = variable_set.rule;
	document.body.appendChild( heading );

	for ( const colour of colour_variables ) {
		my_div.appendChild( make_the_guy(colour, "colour") );
	}

	for ( const image of url_variables ) {
		// let line = document.createElement("div");
		// line.style.display = "flex";
		// line.style.gap = block_size;

		my_div.appendChild( make_the_guy(image, "image") );
		// my_div.appendChild(line);
	}

	document.body.appendChild( my_div );

}
