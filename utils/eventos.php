<?php 
// Exibe na tela todos os eventos da loja.
require_once './app/Mage.php';
Mage::init();

$rewrites = Mage::getConfig()->getNode()->xpath('//global//events');
echo '<table>';
foreach ($rewrites as $key => $rewrite) {
    foreach ($rewrite as $name => $rw) {
        echo '<tr>';
        echo '<td>';
        echo $name;
        echo '</td>';
        echo '<td>';
        print_r(array_shift(json_decode(json_encode($rw), true)));
        echo '</td>';
        echo '</tr>';
    }
}
echo '</table>';
