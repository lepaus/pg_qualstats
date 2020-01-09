/*"""
.. function:: pg_qualstats_reset()

  Resets statistics gathered by pg_qualstats.
*/
CREATE FUNCTION pg_qualstats_reset()
RETURNS void
AS 'MODULE_PATHNAME'
LANGUAGE C;

/*"""
.. function pg_qualstats_example_query(bigint)

  Returns an example for a normalized query, given its queryid
*/
CREATE FUNCTION pg_qualstats_example_query(bigint)
RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C;


/*"""
.. function pg_qualstats_example_queries()

  Returns all the example queries with their associated queryid
*/
CREATE FUNCTION pg_qualstats_example_queries(OUT queryid bigint, OUT query text)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C;


/*"""
.. function:: pg_qualstats()

  Returns:
    A SETOF record containing the data gathered by pg_qualstats

    Attributes:
      userid (oid):
        the user who executed the query
      dbid (oid):
        the database on which the query was executed
      lrelid (oid):
        oid of the relation on the left hand side
      lattnum (attnum):
        attribute number of the column on the left hand side
      opno (oid):
        oid of the operator used in the expression
      rrelid (oid):
        oid of the relation on the right hand side
      rattnum (attnum):
        attribute number of the column on the right hand side
      qualid(bigint):
        hash of the parent ``AND`` expression, if any. This is useful for identifying
        predicates which are used together.
      uniquequalid(bigint):
        hash of the parent ``AND`` expression, if any, including the constant
        values.
      qualnodeid(bigint):
        the predicate hash.
      uniquequalnodeid(bigint):
        the predicate hash. Everything (down to constants) is used to compute this hash
      occurences (bigint):
        the number of times this predicate has been seen
      execution_count (bigint):
        the total number of execution of this predicate.
      nbfiltered (bigint):
        the number of lines filtered by this predicate
      min_err_estimate_ratio(double precision):
        the minimum selectivity estimation error ratio for this predicate
      max_err_estimate_ratio(double precision):
        the maximum selectivity estimation error ratio for this predicate
      mean_err_estimate_ratio(double precision):
        the mean selectivity estimation error ratio for this predicate
      stddev_err_estimate_ratio(double precision):
        the standard deviation for selectivity estimation error ratio for this predicate
      min_err_estimate_num(bigint):
        the minimum number of line for selectivity estimation error for this predicate
      max_err_estimate_num(bigint):
        the maximum number of line for selectivity estimation error for this predicate
      mean_err_estimate_num(double precision):
        the mean number of line for selectivity estimation error for this predicate
      stddev_err_estimate_num(double precision):
        the standard deviation for number of line for selectivity estimation error for this predicate
      constant_position (int):
        the position of the constant in the original query, as filled by the lexer.
      queryid (bigint):
        the queryid identifying this query, as generated by pg_stat_statements
      constvalue (varchar):
        a string representation of the right-hand side constant, if
        any, truncated to 80 bytes.
      eval_type (char):
        the evaluation type. Possible values are ``f`` for execution as a filter (ie, after a Scan)
        or ``i`` if it was evaluated as an index predicate. If the qual is evaluated as an index predicate,
        then the nbfiltered value will most likely be 0, except if there was any rechecked conditions.

  Example:

  .. code-block:: sql

      powa=# select * from powa_statements where queryid != 2;
      powa=# select * from pg_qualstats();
      -[ RECORD 1 ]-----+-----------
      userid                    | 10
      dbid                      | 32799
      lrelid                    | 189341
      lattnum                   | 2
      opno                      | 417
      rrelid                    |
      rattnum                   |
      qualid                    |
      uniquequalid              |
      qualnodeid                | 1391544855
      uniquequalnodeid          | 551979005
      occurences                | 1
      execution_count           | 31
      nbfiltered                | 0
      min_err_estimate_ratio    | 32.741935483871
      max_err_estimate_ratio    | 32.741935483871
      mean_err_estimate_ratio   | 32.741935483871
      stddev_err_estimate_ratio | 0
      min_err_estimate_num      | 984
      max_err_estimate_num      | 984
      mean_err_estimate_num     | 984
      stddev_err_estimate_num   | 0
      constant_position         | 47
      queryid                   | -6668685762776610659
      constvalue                | 2::integer
      eval_type                 | f
*/
CREATE FUNCTION pg_qualstats(
  OUT userid oid,
  OUT dbid oid,
  OUT lrelid oid,
  OUT lattnum smallint,
  OUT opno oid,
  OUT rrelid oid,
  OUT rattnum smallint,
  OUT qualid  bigint,
  OUT uniquequalid bigint,
  OUT qualnodeid    bigint,
  OUT uniquequalnodeid bigint,
  OUT occurences bigint,
  OUT execution_count bigint,
  OUT nbfiltered bigint,
  OUT min_err_estimate_ratio double precision,
  OUT max_err_estimate_ratio double precision,
  OUT mean_err_estimate_ratio double precision,
  OUT stddev_err_estimate_ratio double precision,
  OUT min_err_estimate_num bigint,
  OUT max_err_estimate_num bigint,
  OUT mean_err_estimate_num double precision,
  OUT stddev_err_estimate_num double precision,
  OUT constant_position int,
  OUT queryid    bigint,
  OUT constvalue varchar,
  OUT eval_type  "char"
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT VOLATILE;

/*"""
.. function:: pg_qualstats_names()

  This function is the same as pg_qualstats, but with additional columns corresponding
  to the resolved names, if ``pg_qualstats.resolve_oids`` is set to ``true``.

  Returns:
    The same set of columns than :func:`pg_qualstats()`, plus the following ones:

    rolname (text):
      the name of the role executing the query. Corresponds to userid.
    dbname (text):
      the name of the database on which the query was executed. Corresponds to dbid.
    lrelname (text):
      the name of the relation on the left-hand side of the qual. Corresponds to lrelid.
    lattname (text):
      the name of the attribute (column) on the left-hand side of the qual. Corresponds to rrelid.
    opname (text):
      the name of the operator. Corresponds to opno.
*/
CREATE FUNCTION pg_qualstats_names(
  OUT userid oid,
  OUT dbid oid,
  OUT lrelid oid,
  OUT lattnum smallint,
  OUT opno oid,
  OUT rrelid oid,
  OUT rattnum smallint,
  OUT qualid  bigint,
  OUT uniquequalid bigint,
  OUT qualnodeid    bigint,
  OUT uniquequalnodeid bigint,
  OUT occurences bigint,
  OUT execution_count bigint,
  OUT nbfiltered bigint,
  OUT constant_position int,
  OUT queryid    bigint,
  OUT constvalue varchar,
  OUT eval_type  "char",
  OUT rolname text,
  OUT dbname text,
  OUT lrelname text,
  OUT lattname  text,
  OUT opname text,
  OUT rrelname text,
  OUT rattname text
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT VOLATILE;


-- Register a view on the function for ease of use.
/*"""
.. view:: pg_qualstats

  This view is just a simple wrapper on the :func:`pg_qualstats()` function, filtering on the current database for convenience.
*/
CREATE VIEW pg_qualstats AS
  SELECT qs.* FROM pg_qualstats() qs
  INNER JOIN pg_database on qs.dbid = pg_database.oid
  WHERE pg_database.datname = current_database();


GRANT SELECT ON pg_qualstats TO PUBLIC;

-- Don't want this to be available to non-superusers.
REVOKE ALL ON FUNCTION pg_qualstats_reset() FROM PUBLIC;

/*"""
.. view:: pg_qualstats_pretty

  This view resolves oid "on the fly", for the current database.

  Returns:
    left_schema (name):
      the name of the left-hand side relation's schema.
    left_table (name):
      the name of the left-hand side relation.
    left_column (name):
      the name of the left-hand side attribute.
    operator (name):
      the name of the operator.
    right_schema (name):
      the name of the right-hand side relation's schema.
    right_table (name):
      the name of the right-hand side relation.
    right_column (name):
      the name of the operator.
    execution_count (bigint):
      the total number of time this qual was executed.
    nbfiltered (bigint):
      the total number of tuples filtered by this qual.
*/
CREATE VIEW pg_qualstats_pretty AS
  select
        nl.nspname as left_schema,
        al.attrelid::regclass as left_table,
        al.attname as left_column,
        opno::regoper::text as operator,
        nr.nspname as right_schema,
        ar.attrelid::regclass as right_table,
        ar.attname as right_column,
        sum(occurences) as occurences,
        sum(execution_count) as execution_count,
        sum(nbfiltered) as nbfiltered
  from pg_qualstats qs
  left join (pg_class cl inner join pg_namespace nl on nl.oid = cl.relnamespace) on cl.oid = qs.lrelid
  left join (pg_class cr inner join pg_namespace nr on nr.oid = cr.relnamespace) on cr.oid = qs.rrelid
  left join pg_attribute al on al.attrelid = qs.lrelid and al.attnum = qs.lattnum
  left join pg_attribute ar on ar.attrelid = qs.rrelid and ar.attnum = qs.rattnum
  group by al.attrelid, al.attname, ar.attrelid, ar.attname, opno, nl.nspname, nr.nspname
;


CREATE OR REPLACE VIEW pg_qualstats_all AS
  SELECT dbid, relid, userid, queryid, array_agg(distinct attnum) as attnums,
    opno, max(qualid) as qualid, sum(occurences) as occurences,
    sum(execution_count) as execution_count, sum(nbfiltered) as nbfiltered,
    coalesce(qualid, qualnodeid) as qualnodeid
  FROM (
    SELECT
          qs.dbid,
          CASE WHEN lrelid IS NOT NULL THEN lrelid
               WHEN rrelid IS NOT NULL THEN rrelid
          END as relid,
          qs.userid as userid,
          CASE WHEN lrelid IS NOT NULL THEN lattnum
               WHEN rrelid IS NOT NULL THEN rattnum
          END as attnum,
          qs.opno as opno,
          qs.qualid as qualid,
          qs.qualnodeid as qualnodeid,
          qs.occurences as occurences,
          qs.execution_count as execution_count,
          qs.nbfiltered as nbfiltered,
          qs.queryid
    FROM pg_qualstats() qs
    WHERE lrelid IS NOT NULL or rrelid IS NOT NULL
  ) t GROUP BY dbid, relid, userid, queryid, opno, coalesce(qualid, qualnodeid)
;

/*"""
.. type:: qual

  Attributes:

    relid (oid):
      the relation oid
    attnum (integer):
      the attribute number
    opno (oid):
      the operator oid
    eval_type (char):
      the evaluation type. See :func:`pg_qualstats()` for an explanation of the eval_type.
*/
CREATE TYPE qual AS (
  relid oid,
  attnum integer,
  opno oid,
  eval_type "char"
 );

/*"""
.. type:: qualname

  Pendant of :type:`qual`, but with names instead of oids

  Attributes:

    relname (text):
      the relation oid
    attname (text):
      the attribute number
    opname (text):
      the operator name
    eval_type (char):
      the evaluation type. See :func:`pg_qualstats()` for an explanation of the eval_type.
*/
CREATE TYPE qualname AS (
  relname text,
  attnname text,
  opname text,
  eval_type "char"
);

CREATE OR REPLACE VIEW pg_qualstats_by_query AS
        SELECT coalesce(uniquequalid, uniquequalnodeid) as uniquequalnodeid, dbid, userid,  coalesce(qualid, qualnodeid) as qualnodeid, occurences, execution_count, nbfiltered, queryid,
      array_agg(constvalue order by constant_position) as constvalues, array_agg(ROW(relid, attnum, opno, eval_type)::qual) as quals
      FROM
      (

        SELECT
            qs.dbid,
            CASE WHEN lrelid IS NOT NULL THEN lrelid
                WHEN rrelid IS NOT NULL THEN rrelid
            END as relid,
            qs.userid as userid,
            CASE WHEN lrelid IS NOT NULL THEN lattnum
                WHEN rrelid IS NOT NULL THEN rattnum
            END as attnum,
            qs.opno as opno,
            qs.qualid as qualid,
            qs.uniquequalid as uniquequalid,
            qs.qualnodeid as qualnodeid,
            qs.uniquequalnodeid as uniquequalnodeid,
            qs.occurences as occurences,
            qs.execution_count as execution_count,
            qs.queryid as queryid,
            qs.constvalue as constvalue,
            qs.nbfiltered as nbfiltered,
            qs.eval_type,
            qs.constant_position
        FROM pg_qualstats() qs
        WHERE (qs.lrelid IS NULL) != (qs.rrelid IS NULL)
    ) i GROUP BY coalesce(uniquequalid, uniquequalnodeid), coalesce(qualid, qualnodeid),  dbid, userid, occurences, execution_count, nbfiltered, queryid
;

CREATE OR REPLACE FUNCTION pg_qualstats_deparse_qual(qual qual) RETURNS TEXT
AS $_$
    SELECT pg_catalog.format('%I.%I %s ?',
        c.oid::regclass, a.attname, o.oprname)
    FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_attribute a ON a.attrelid = c.oid
    JOIN pg_catalog.pg_operator o ON o.oid = qual.opno
    WHERE c.oid = qual.relid
    AND a.attnum = qual.attnum
$_$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION pg_qualstats_get_qualnode_rel(bigint)
RETURNS TEXT
AS $_$
    SELECT pg_catalog.quote_ident(n.nspname) || '.'
      || pg_catalog.quote_ident(c.relname)
    FROM pg_qualstats() q
    JOIN pg_catalog.pg_class c ON coalesce(q.lrelid, q.rrelid) = c.oid
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE q.qualnodeid = $1
$_$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION pg_qualstats_get_idx_col(bigint,
    include_nondefault_opclass boolean = true)
RETURNS TEXT
AS $_$
    SELECT pg_catalog.quote_ident(a.attname) ||
    CASE WHEN include_nondefault_opclass THEN
      CASE WHEN opc.opcdefault THEN ''
      ELSE ' ' || pg_catalog.quote_ident(opcname)
      END
    ELSE
    ''
    END
    FROM pg_qualstats() q
    JOIN pg_catalog.pg_class c ON coalesce(q.lrelid, q.rrelid) = c.oid
    JOIN pg_catalog.pg_attribute a ON a.attrelid = c.oid
      AND a.attnum = coalesce(q.lattnum, q.rattnum)
    JOIN pg_catalog.pg_operator op ON op.oid = q.opno
    JOIN pg_catalog.pg_amop amop ON amop.amopopr = op.oid
    JOIN pg_catalog.pg_am am ON am.oid = amop.amopmethod
    JOIN pg_catalog.pg_opfamily f ON f.opfmethod = am.oid
      AND amop.amopfamily = f.oid
    JOIN pg_catalog.pg_opclass opc ON opc.opcfamily = f.oid
    WHERE q.qualnodeid = $1
    ORDER BY CASE opcdefault WHEN true THEN 0 ELSE 1 END;
$_$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION pg_qualstats_index_advisor (
    min_filter integer DEFAULT 1000,
    min_selectivity integer DEFAULT 30,
    forbidden_am text[] DEFAULT '{}')
    RETURNS jsonb
AS $_$
DECLARE
    v_res jsonb;
    v_processed bigint[];
    v_indexes text[] = '{}';
    v_unoptimised text[] = '{}';

    rec record;
    v_nb_processed integer = 1;

    v_ddl text;
    v_col text;
    v_cur jsonb;
    v_qualnodeid bigint;
    v_quals_todo bigint[];
    v_quals_done bigint[];
    v_quals_col_done text[];
BEGIN
    -- sanity checks and default values
    SELECT coalesce(min_filter, 1000), coalesce(min_selectivity, 30),
      coalesce(forbidden_am, '{}')
    INTO min_filter, min_selectivity, forbidden_am;

    -- don't try to generate hash indexes Before pg 10, as those are only WAL
    -- logged since pg 11.
    IF pg_catalog.current_setting('server_version_num')::bigint < 100000 THEN
        forbidden_am := array_append(forbidden_am, 'hash');
    END IF;

    -- first find out unoptimizable quals
    FOR rec IN SELECT DISTINCT qualnodeid,
        (coalesce(lrelid, rrelid), coalesce(lattnum, rattnum),
          opno, eval_type)::qual AS qual
      FROM pg_qualstats() q
      JOIN pg_catalog.pg_database d ON q.dbid = d.oid
      LEFT JOIN pg_catalog.pg_operator op ON op.oid = q.opno
      LEFT JOIN pg_catalog.pg_amop amop ON amop.amopopr = op.oid
      LEFT JOIN pg_catalog.pg_am am ON am.oid = amop.amopmethod
      WHERE d.datname = current_database()
       AND eval_type = 'f'
       AND coalesce(lrelid, rrelid) != 0
       AND amname IS NULL
    LOOP
      v_unoptimised := pg_catalog.array_append(v_unoptimised,
        pg_qualstats_deparse_qual(rec.qual));
      v_processed := pg_catalog.array_append(v_processed, rec.qualnodeid);
    END LOOP;

    -- The index suggestion is done in multiple iteration, by scoring for each
    -- relation containing interesting quals a path of possibly AND-ed quals
    -- that contains other possibly AND-ed quals.  Only the higher score path
    -- will be used to create an index, so we can then compute another set of
    -- paths ignoring the quals that are now optimized with an index.
    WHILE v_nb_processed > 0 LOOP
      v_nb_processed := 0;
      FOR rec IN
        -- first, find quals that seems worth to optimize along with the
        -- possible access methods, discarding any qualnode that are marked as
        -- already processed.  Also apply access method restriction.
        WITH pgqs AS (
          SELECT dbid, amname, qualid, qualnodeid,
            (coalesce(lrelid, rrelid), coalesce(lattnum, rattnum),
            opno, eval_type)::qual AS qual,
            round(avg(execution_count)) AS execution_count,
            sum(occurences) AS occurences,
            round(sum(nbfiltered)::numeric / sum(occurences)) AS avg_filter,
            CASE WHEN sum(execution_count) = 0
              THEN 0
              ELSE round(sum(nbfiltered::numeric) / sum(execution_count) * 100)
            END AS avg_selectivity
          FROM pg_qualstats() q
          JOIN pg_catalog.pg_database d ON q.dbid = d.oid
          JOIN pg_catalog.pg_operator op ON op.oid = q.opno
          JOIN pg_catalog.pg_amop amop ON amop.amopopr = op.oid
          JOIN pg_catalog.pg_am am ON am.oid = amop.amopmethod
          WHERE d.datname = current_database()
          AND eval_type = 'f'
          AND amname != ALL (forbidden_am)
          AND coalesce(lrelid, rrelid) != 0
          AND qualnodeid != ALL(v_processed)
          GROUP BY dbid, amname, qualid, qualnodeid, lrelid, rrelid,
            lattnum, rattnum, opno, eval_type
        ),
        -- apply cardinality and selectivity restrictions
        filtered AS (
          SELECT (qual).relid, amname, coalesce(qualid, qualnodeid) AS parent,
            count(*) AS weight, array_agg(qualnodeid) AS quals
          FROM pgqs
          WHERE avg_filter >= min_filter
          AND avg_selectivity >= min_selectivity
          GROUP BY (qual).relid, amname, parent
        ),
        -- for each possibly AND-ed qual, build the list of included qualnodeid
        nodes AS (
          SELECT p.relid, p.amname, p.parent, p.quals,
            c.quals AS children
          FROM filtered p
          LEFT JOIN filtered c ON p.quals @> c.quals
            AND p.amname = c.amname
            AND p.parent != c.parent
            AND p.quals != c.quals
        ),
        -- build the "paths", which is the list of AND-ed quals that entirely
        -- contains another possibly AND-ed quals, and give a score for each
        -- path.  The scoring method used here is simply the number of
        -- columns in the quals.
        paths AS (
          SELECT DISTINCT *, coalesce(pg_catalog.array_length(children, 1), 0) AS weight
          FROM nodes
          UNION
          SELECT DISTINCT p.relid, p.amname, p.parent, p.quals, c.children,
            coalesce(pg_catalog.array_length(c.children, 1), 0) AS weight
          FROM nodes p
          JOIN nodes c ON p.children @> c.quals AND c.quals IS NOT NULL
            AND c.quals != p.quals
            AND p.amname = c.amname
        ),
        -- compute the final paths.
        -- The scoring method used here is simply the sum of total
        -- number of columns in each possibly AND-ed quals, so that we can
        -- later chose to create indexes that optimize as many queries as
        -- possible with as few indexes as possible.
        -- We also compute here an access method weight, so that we can later
        -- choose a btree index rather than another access method if btree is
        -- available.
        computed AS (
          SELECT relid, amname, parent, quals,
            array_agg(to_json(children) ORDER BY weight)
              FILTER (WHERE children IS NOT NULL) AS included,
            pg_catalog.array_length(quals, 1) + sum(weight) AS path_weight,
          CASE amname WHEN 'btree' THEN 1 ELSE 2 END AS amweight
          FROM paths
          GROUP BY relid, amname, parent, quals
        ),
        -- compute a rank for each final paths, per relation.
        final AS (
          SELECT relid, amname, parent, quals, included, path_weight, amweight,
          row_number() OVER (
            PARTITION BY relid
            ORDER BY path_weight DESC, amweight) AS rownum
          FROM computed
        )
        -- and finally choose the higher rank final path for each relation.
        SELECT relid, amname, parent, quals, included, path_weight
        FROM final
        WHERE rownum = 1
      LOOP
        v_nb_processed := v_nb_processed + 1;

        v_ddl := '';
        v_quals_todo := '{}';
        v_quals_done := '{}';
        v_quals_col_done := '{}';

        -- put columns from included quals, if any, first for order dependency
        IF rec.included IS NOT NULL THEN
          FOREACH v_cur IN ARRAY rec.included LOOP
            -- Direct cast from jsonb to bigint is only possible since pg10
            FOR v_qualnodeid IN SELECT pg_catalog.jsonb_array_elements(v_cur)::text::bigint
            LOOP
              v_quals_todo := v_quals_todo || v_qualnodeid;
            END LOOP;
          END LOOP;
        END IF;

        -- and append qual's own columns
        v_quals_todo := v_quals_todo || rec.quals;

        -- generate the index DDL
        FOREACH v_qualnodeid IN ARRAY v_quals_todo LOOP
          -- skip quals already present in the index
          CONTINUE WHEN v_quals_done @> ARRAY[v_qualnodeid];

          -- skip other quals for the same column
          v_col := pg_qualstats_get_idx_col(v_qualnodeid, false);
          CONTINUE WHEN v_quals_col_done @> ARRAY[v_col];

          -- mark this qual as present in a generated index so it's ignore at
          -- next round of best quals to optimize
          v_processed := pg_catalog.array_append(v_processed, v_qualnodeid);

          -- mark this qual and col as present in this index
          v_quals_done := v_quals_done || v_qualnodeid;
          v_quals_col_done := v_quals_col_done || v_col;

          -- if underlying table has been dropped, stop here
          CONTINUE WHEN coalesce(v_col, '') = '';

          -- append the column to the index
          IF v_ddl != '' THEN v_ddl := v_ddl || ', '; END IF;
          v_ddl := v_ddl || pg_qualstats_get_idx_col(v_qualnodeid, true);
        END LOOP;

        -- if underlying table has been dropped, skip this (broken) index
        CONTINUE WHEN coalesce(v_ddl, '') = '';

        -- generate the full CREATE INDEX ddl
        v_ddl = pg_catalog.format('CREATE INDEX ON %s USING %I (%s)',
          pg_qualstats_get_qualnode_rel(v_qualnodeid), rec.amname, v_ddl);

        -- and append it to the list of generated indexes
        v_indexes := array_append(v_indexes, v_ddl);
      END LOOP;
    END LOOP;

    v_res := pg_catalog.jsonb_build_object('indexes', v_indexes,
        'unoptimised', v_unoptimised);

    RETURN v_res;
END;
$_$ LANGUAGE plpgsql;
