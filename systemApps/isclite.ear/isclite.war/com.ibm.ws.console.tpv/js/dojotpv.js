//IBM Confidential OCO Source Material
// THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
// 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 2010
// All Rights Reserved * Licensed Materials - Property of IBMUS 
// Government Users Restricted Rights - Use, duplication or disclosure
// restricted by GSA ADP Schedule Contract with IBM Corp.



function drawTPVInitialGraph ( name, xaxis, yaxis, plot ){
   			chart = new dojox.charting.Chart2D(name);
			chart.addAxis("x", xaxis);
			chart.addAxis("y", yaxis);
			chart.addPlot("default", plot );
			var anim3b = new dojox.charting.action2d.Tooltip(chart, "default");
			chart.addPlot("grid", {type: "Grid", hMinorLines: false});
			chart.render();
	} 

	// Method to generate the Legends for the graph drawn using the above algorithm.
	function createLegend (nodes,chart) {
		for (l = 0; l < nodes.length; l++) {
			div = nodes [l];
			dyn = chart.series[l].dyn;
			var mb = { h: 30, w: 40 };
			var surface = dojox.gfx.createSurface(div, mb.w, mb.h);
			// draw line
			var line = {x1: 0, y1: mb.h / 2, x2: mb.w, y2: mb.h / 2};
				if(dyn.stroke){
					surface.createLine(line).setStroke(dyn.stroke);
				}
				if(dyn.marker){
				// draw marker on top
				var c = {x: mb.w / 2, y: mb.h / 2};
				if(dyn.stroke){
					surface.createPath({path: "M" + c.x + " " + c.y + " " + dyn.marker}).
						setFill(dyn.stroke.color).setStroke(dyn.stroke);
				}else{
					surface.createPath({path: "M" + c.x + " " + c.y + " " + dyn.marker}).
						setFill(dyn.color).setStroke(dyn.color);
				}
			}
			div.style.width = "0px";
			div.style.height = "0px";
		}		
	}
	
	function makeAxisTitle(chart,axis,name){

	    var dim = chart.dim;
	    var offsets=chart.offsets;
	    var x;
	    var y;
	    var label;
	    var rotate=0;
	    if(axis.vertical){
	        rotate=270
	        label = name;
	        y=dim.height/2  - offsets.b/2;
	        x=0+12;
	    }else{
	        label = name;
	        x=dim.width/2 + offsets.l/2;
	        y=dim.height;
	    }
	    var m = dojox.gfx.matrix;
	    var elem = axis.group.createText({x:x, y:y, text:label, align: "middle"});
	    elem.setFont({size: "12pt", weight: "bold"});
	    elem.setFill('black');
	    elem.setTransform(m.rotategAt(rotate, x,y));
	}