let overlay = document.querySelector(".overlay");
document
	.querySelector(".menu-item.responsive button")
	.addEventListener("click", function () {
		overlay.style.display = "block";
		document.querySelectorAll(".overlay .menu-item").forEach(function (item) {
			item.style.display = "block";
		});
	});
overlay.addEventListener("click", function () {
	this.style.display = "none";
});
