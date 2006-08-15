    select sq.q_template_v_id as scorecard_question_id,  
            s.scorecard_id,  
            (select submitter_id from submission where submission_id = s.submission_id and cur_version=1) as user_id,  
            s.author_id as reviewer_id,  
            s.project_id,  
            sr.response_text,  
            sr.response_type_id,  
            (select response_type_name from response_type where sr.response_type_id = response_type_id) as response_type_desc,  
             subjective_resp_id  
            from subjective_resp sr, scorecard s, scorecard_question sq  
            where s.scorecard_id = sq.scorecard_id  
            and sq.question_id = sr.question_id  
            and s.cur_version = 1  
            and sr.cur_version = 1  
            and sq.cur_version = 1  
            and project_id = ?  
            and (sr.modify_date>? OR s.modify_date>? OR sq.modify_date>?)  
            order by scorecard_question_id, scorecard_id, subjective_resp_id
            

            
	select ri.review_item_id  as scorecard_question_id,  
        ri.review_id as scorecard_id,  
        (select value from resource_info where resource_id = s.resource_id and resource_info_type_id = 1) as user_id,
        (select value from resource_info where resource_id = r.resource_id and resource_info_type_id = 1) as reviewer_id,
        s.project_id,  
        ric.content as response_text,
        ric.comment_type_id as response_type_id,
        (select name from comment_type_lu where comment_type_id = ric.comment_type_id) as response_type_desc,
        ric.review_item_comment_id 
        from review_item_comment ric, review_item  ri, review r, submission s 
        where ric.review_item_id = ri.review_item_id 
        and ri.review_id = r.review_id  
        and r.submission_id = s.submission_id
        and (ric.comment_type_id >= 1 and ric.comment_type_id <= 3) 
        and (ric.modify_date > ? OR ri.modify_date > ? OR r.modify_date > ? OR s.modify_date > ?)
    	and r.resource_id in (select resource_id from resource where resource_role_id >= 2 && resource_role_id <= 7) 
    	order by scorecard_question_id, scorecard_id, review_item_comment_id 