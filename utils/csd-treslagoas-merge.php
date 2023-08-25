<?php

define("ROOTDIR", dirname($argv[0]));

if (!is_dir(ROOTDIR . '/csd-tres-lagoas')) {
    exec('git clone git@git2bis.com.br:bis2bis/bis2bis-stores/csd-tres-lagoas.git');
} else {
    echo "LIMPANDO E ATUALIZANDO!" . PHP_EOL;
    exec(
        "cd " . ROOTDIR . "/csd-tres-lagoas;" .
        "git reset --hard HEAD;" .
        "git clean -fd;" .
        "git checkout master;" .
        "git fetch;" .
        "git pull;" .
        "clear"
    );
    echo "LIMPO E ATUALIZADO!" . PHP_EOL;
}

exec("cd " . ROOTDIR . "/csd-tres-lagoas;git branch -r", $branchs);
echo "========================================= " . PHP_EOL;

foreach ($branchs as $branch) {
    print_r("INICIANDO MERGE: {$branch}" . PHP_EOL);
    if (
        strpos($branch, "readme") != false || 
        strpos($branch, "master") != false ||
        strpos($branch, "hotfix") != false ||
        strpos($branch, "feature") != false ||
        strpos($branch, "290729-retiraremloja") != false
    ) {
        echo "Nada para mergear em {$branch}" . PHP_EOL;
        echo "===========================" . PHP_EOL;
        continue;
    }

    $branch = trim(str_replace("origin/", "", $branch));

    exec(
        "cd " . ROOTDIR . "/csd-tres-lagoas;" .
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
