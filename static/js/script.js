document.addEventListener("DOMContentLoaded", function () {

    console.log("PharmaCare Pharmacy Management System loaded.");

    const buttons = document.querySelectorAll(".primary-btn");

    buttons.forEach(function (button) {

        button.addEventListener("click", function () {

            if (button.form && button.form.checkValidity()) {
                button.innerHTML = "Saving...";
            }

        });

    });

});