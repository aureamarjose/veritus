// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'flowbite'
// import 'flowbite-datepicker'
import "chartkick"
import "Chart.bundle"

// Importações do flatpickr
import flatpickr from "flatpickr";
import { English } from "./en.js";

// Configura o flatpickr para usar a tradução em português globalmente
flatpickr.localize(English);

