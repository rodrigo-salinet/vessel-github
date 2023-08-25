<?php

define("ROOTDIR", dirname($argv[0]));

if (!is_dir(ROOTDIR . '/cidade-cancao-csd')) {
    exec('git clone git@git2bis.com.br:bis2bis/bis2bis-stores/cidade-cancao-csd.git');
} else {
    echo "LIMPANDO E ATUALIZANDO!" . PHP_EOL;
    exec(
        "cd " . ROOTDIR . "/cidade-cancao-csd;" .
        "git reset --hard HEAD;" .
        "git clean -fd;" .
        "git checkout master;" .
        "git fetch;" .
        "git pull;" .
        "clear"
    );
    echo "LIMPO E ATUALIZADO!" . PHP_EOL;
}


exec("cd " . ROOTDIR . "/cidade-cancao-csd;git branch -r", $branchs);
echo "========================================= " . PHP_EOL;

foreach ($branchs as $branch) {
    print_r("INICIANDO MERGE: {$branch}" . PHP_EOL);
    if (
        strpos($branch, "readme") != false || 
        strpos($branch, "master") != false || 
        strpos($branch, "master-flux") != false || 
        strpos($branch, "apucarana") != false ||
        strpos($branch, "feature") != false ||
        strpos($branch, "hotfix") != false ||
        strpos($branch, "maringavelho-customer-integration") != false ||
        strpos($branch, "instaleap-maringa-velho") != false ||
        strpos($branch, "maringavelho") != false ||
        strpos($branch, "staging") != false
    ) {
        echo "Nada para mergear em {$branch}" . PHP_EOL;
        echo "===========================" . PHP_EOL;
        continue;
    }

    $branch = trim(str_replace("origin/", "", $branch));

    exec(
        "cd " . ROOTDIR . "/cidade-cancao-csd;" .
        "git checkout master;" .
        "git status;" .
        "git fetch origin;" .
        'git checkout "' . $branch . '";' .
        'git merge --no-ff "master";' .
        'git push origin "' . $branch . '";', $output
    );
    file_put_contents(ROOTDIR . '/var/output.log', print_r($output, true), FILE_APPEND);
    file_put_contents(ROOTDIR . '/var/output.log', "===================================================================================================" . PHP_EOL, FILE_APPEND);

    print_r("FINALIZADO MERGE: {$branch}" . PHP_EOL);
    echo "========================================= " . PHP_EOL;
}
